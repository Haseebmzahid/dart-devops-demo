import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:redis/redis.dart';

void main() async {
  print("Attempting to connect to Redis...");

  // --- FIX START ---
  // We use RedisConnection to establish the link first
  final conn = RedisConnection();
  
  // Connect to the host "redis" on port 6379
  // This returns a "Command" object we can use to send commands
  final command = await conn.connect('redis', 6379);
  // --- FIX END ---

  print('Connected to Redis successfully!');

  // Define our handler
  Future<Response> handler(Request request) async {
    // Let's try to increment a counter in Redis
    try {
      await command.send_object(["INCR", "visitors"]);
      var count = await command.send_object(["GET", "visitors"]);
      return Response.ok('WELCOME TO VERSION 2! The visitor count is: $count\n');
    } catch (e) {
      return Response.ok('Hello from Dart! (Redis database is warming up)\n');
    }
  }

  // Start the Server
  final ip = InternetAddress.anyIPv4;
  final port = 8080;
  final server = await serve(handler, ip, port);
  print('Server running on port ${server.port}');
}