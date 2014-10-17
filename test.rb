require 'poiful'

LineProf.start do
  sleep 0.1
  2**32
end

LineProf.begin
sleep 0.1
2**1024
2 * 2
LineProf.end
