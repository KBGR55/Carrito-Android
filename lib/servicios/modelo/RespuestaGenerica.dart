import 'dart:ffi';

class RespuestaGenerica{
  String msg = "";
  int code = 0;
  dynamic info = "";
  RespuestaGenerica({this.code = 0, this.msg = "", this.info});
}