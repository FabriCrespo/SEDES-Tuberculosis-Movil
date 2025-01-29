import 'package:flutter/material.dart';

class RecuperarPage extends StatelessWidget {
 const RecuperarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F8EC), // Fondo color crema
      appBar: AppBar(
        title: Text(
          'Recuperar contraseña',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4E6BA6),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Icon(
                Icons.lock_reset,
                size: 100,
                color: Color(0xFFD34B82), // Rosa
              ),
             SizedBox(height: 20),
             Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E6BA6), // Azul
                ),
                textAlign: TextAlign.center,
              ),
             SizedBox(height: 16),
             Text(
                'No te preocupes, te enviaremos un correo para restablecerla.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9AD1C7), // Aqua
                ),
              ),
             SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      color: Color(0xFFD34B82), // Borde rosa
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      color: Color(0xFF4E6BA6), // Borde azul al enfocar
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
             SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                      content: Text(
                        'Correo enviado con éxito.',
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Color(0xFF4E6BA6),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 55),
                  backgroundColor: Color(0xFF4E6BA6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Enviar Instrucciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
             SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Volver al inicio de sesión',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFD34B82), // Rosa
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
