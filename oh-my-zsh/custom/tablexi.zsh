function grabtemplates {
  echo "Copying from templates: "
  for f in config/*.template; do
    local new=${f%.template};
    if [ -f $new ]
    then
      echo "  [SKIP] $new"
    else
      cp $f $new;
      echo "  [COPY] $new";
    fi
  done
}

# git related

alias gmaster='git checkout master && git merge develop && git push origin master'

# npm / bower

alias nombom="npm cache clear && bower cache clean && rm -rf node_modules bower_components && npm install && bower install"

# CIW
alias ciw-prod-push='git push production master'
alias ciw-prod-migrate='heroku run rake db:migrate --app chicagoideas'
alias ciw-prod-restart='heroku restart --app chicagoideas'
alias ciw-prod-sphinx='heroku run bundle exec flying-sphinx configure --app chicagoideas && heroku run bundle exec flying-sphinx rebuild --app chicagoideas'
alias ciw-stage-sphinx='heroku run bundle exec flying-sphinx configure --app chicagoideas-staging && heroku run bundle exec flying-sphinx rebuild --app chicagoideas-staging'
alias ciw-prod-deploy='ciw-prod-push && ciw-prod-migrate && ciw-prod-restart && ciw-prod-sphinx'

# D1
export DYNAMO_LOCAL_PATH="${HOME}/Library/DynamoDB/current"
