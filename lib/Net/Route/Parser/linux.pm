package Net::Route::Parser::linux;

use Moose;
if(0 && -x "/sbin/route")
{
  extends 'Net::Route::Parser::linux::sbinroute';
}
else
{
  extends 'Net::Route::Parser::linux::proc';
}

1;
