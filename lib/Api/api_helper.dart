import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'my_exceptions.dart';

class ApiHelper{

  Future<dynamic> getBlogData()async{

    try{
      var res = await http.get(Uri.parse('https://intent-kit-16.hasura.app/api/rest/blogs'),
          headers: {'x-hasura-admin-secret' : '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6'}
      );
      return returnDataResponse(res);
    }on SocketException{
      throw FetchDataException(body: "Internet Error");
    }

  }

  dynamic returnDataResponse(http.Response res){
    switch(res.statusCode){

      case 200:
        var mData = res.body;
        return jsonDecode(mData);

      case 400:
        throw BadRequestException(body: res.body.toString());

      case 401:
      case 403:
      case 407:
        throw UnAuthorisedException(body: res.body.toString());

      case 500:
      default:
        throw FetchDataException(body: "Error while communicating to server");

    }
  }

}