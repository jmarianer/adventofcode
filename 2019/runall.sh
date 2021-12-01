for i in `seq 25` ; do
  if [ -f input$i ] ; then
    python3 $i.py < input$i
  else
    python3 $i.py
  fi
done
