var request = require('request')
var passport = require('passport')
var GithubStrategy = require('passport-github2').Strategy


exports.setup = function(express, app, config) {

    console.log('Github OAuth2 authentication used')

    console.log(express, app, config) // REMOVE
    passport.serializeUser(function(user, done) {
      done(null, user)
    })

    passport.deserializeUser(function(obj, done) {
      done(null, obj)
    })

    var callbackUrl = config.host + '/auth/github/callback'

    passport.use(new GithubStrategy({
            clientID: config.oauth_client_id,
            clientSecret: config.oauth_client_secret,
            callbackURL: callbackUrl
        }, function(accessToken, refreshToken, profile, done) {
            // User.findOrCreate({ githubId: profile.id }, function (err, user) {
            //     return done(err, user);
            // });
            // findUser(profile, accessToken, config, function(succeed, msg) {
            //     return succeed ? done(null, profile): done(null, false, { message: msg})
            // })
            console.log(accessToken, refreshToken, profile)
    }));

    app.use(function(req, res, next) {
        if (req.isAuthenticated()) {
            return next();
        }
        // Not logged in
        res.redirect('/auth/github');
        }

        // if (req.session.authenticated || nonAuthenticated(config, req.url) || verifyApiKey(config, req)) {
        //     return next()
        // }
        // req.session.beforeLoginURL = req.url
        // res.redirect('/auth/github')
    // 
    )
    app.use(passport.initialize())
    app.use(passport.session())


// export function ensureAuthenticated(req, res, next) {
//     if (req.isAuthenticated()) {
//         return next();
//     }
//     // Not logged in
//     return res.redirect('/auth/github');
//     }


    // var scope = ['https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/userinfo.email']

    app.get('/auth/github',
        passport.authenticate('github', { scope: [ 'user:email' ] }),
            function(req, res) {
                /* do nothing as this request will be redirected to google for authentication */
            }
    )

    app.get('/auth/github/callback',
        passport.authenticate('github', { failureRedirect: '/auth/github/fail' }),
            function(req, res) {
                /* Successful authentication, redirect home. */
                req.session.authenticated = true
                res.redirect(req.session.beforeLoginURL || '/')
            }
    )

    app.get('/auth/github/fail', function(req, res) {
        res.statusCode = 403
        res.end('<html><body>Unauthorized</body></html>')
    })
}

function nonAuthenticated(config, url) {
    return url.indexOf('/auth/github') === 0 || config.oauth_unauthenticated.indexOf(url) > -1
}

function findUser(profile, accessToken, config, callback)  {
    var username = profile.displayName || 'unknown';
    var email = profile.emails[0].value || '';
    var domain = profile._json.domain || '';

    if ( (  email.split('@')[1] === config.allowed_domain ) || domain === config.allowed_domain ) {
        return callback(true, username)
    } else {
        console.log('access refused to: ' + username + ' (email=' + email + ';domain=' + domain + ')');
        return callback(false, username + ' is not authorized')
    }
}

function verifyApiKey(config, req)  {
    var apiKey = req.headers['authorization'] || '';
    return (config.apiKey.length > 0 && "ApiKey " + config.apiKey === apiKey)
}
