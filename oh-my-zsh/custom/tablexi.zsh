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

