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

alias ssh-bella="ssh bellababy@bellababy.stage.tablexi.com"
alias ssh-bella-uat="ssh bellababyuat@bellababyuat.stage.tablexi.com"
alias ssh-flow="ssh uncommonflow@uncommon-flow.stage.tablexi.com"
alias ssh-dickson="ssh viewmydata@viewmydata.stage.tablexi.com"
alias ssh-push="ssh push@pushforwellness.stage.tablexi.com"
alias migrate="rake db:migrate && rake db:test:prepare && annotate"

