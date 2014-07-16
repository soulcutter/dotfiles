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

# SSH shortcuts 
alias ssh-bella="ssh bellababy@bellababy.stage.tablexi.com"
alias ssh-bella-uat="ssh bellababyuat@bellababyuat.stage.tablexi.com"
alias ssh-flow="ssh uncommonflow@uncommon-flow.stage.tablexi.com"
alias ssh-dickson="ssh viewmydata@viewmydata.stage.tablexi.com"
alias ssh-push="ssh push@pushforwellness.stage.tablexi.com"

# git related

alias gmaster='git checkout master && git merge develop && git push origin master'

# CIW
alias ciw-prod-push='git push production master'
alias ciw-prod-migrate='heroku run rake db:migrate --app chicagoideas'
alias ciw-prod-restart='heroku restart --app chicagoideas'
alias ciw-prod-sphinx='heroku run bundle exec flying-sphinx configure --app chicagoideas && heroku run bundle exec flying-sphinx rebuild --app chicagoideas'
alias ciw-prod-deploy='ciw-prod-push && ciw-prod-migrate && ciw-prod-restart && ciw-prod-sphinx'

