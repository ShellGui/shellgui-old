#!/bin/sh

main()
{
echo "$FORM_app"
cat <<EOF
$QS_app $QS_action
$FORM_app
`which proccgi`
$FORM_action
<pre>
`env`
</pre>
<input id="myCar" class="form-control list="cars" />
<datalist id="cars">
  <option value="BMW">
  <option value="Ford">
  <option value="Volvo">
</datalist>
EOF
}

lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi