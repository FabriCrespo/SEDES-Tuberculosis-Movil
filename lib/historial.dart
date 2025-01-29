import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'menu_usuario.dart';

class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  _HistorialState createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  final Map<String, List<Map<String, String>>> registradasList = {
    "Primera Fase\n(01/01/2025 - 31/02/2025)": [
      {
        "fecha": "2025-01-01",
        "hora": "08:00 AM",
        "nombre": "Dosis A",
        "descripcion": "Primera dosis diaria cumplida.",
        "ubicacion": "Hospital Central",
        "tipo": "Inyección"
      },
      {
        "fecha": "2025-01-02",
        "hora": "08:00 AM",
        "nombre": "Dosis B",
        "descripcion": "Segunda dosis diaria completada.",
        "ubicacion": "Clínica Los Ángeles",
        "tipo": "Pastilla"
      },
    ],
    "Segunda Fase\n(01/03/2025 - 31/07/2025)": [
      {
        "fecha": "2025-03-01",
        "hora": "08:00 PM",
        "nombre": "Dosis C",
        "descripcion": "Última dosis del día cumplida.",
        "ubicacion": "Farmacia Salud",
        "tipo": "Inyección"
      },
    ],
  };

  final Map<String, List<Map<String, String>>> pendientesList = {
    "Primera Fase\n(01/01/2025 - 31/02/2025)": [
      {
        "fecha": "2025-01-03",
        "hora": "09:00 AM",
        "nombre": "Dosis D",
        "descripcion": "Dosis pendiente de vitaminas.",
        "ubicacion": "Hospital Central",
        "tipo": "Pastilla"
      },
    ],
    "Segunda Fase\n(01/03/2025 - 31/07/2025)": [
      {
        "fecha": "2025-03-04",
        "hora": "10:00 AM",
        "nombre": "Dosis E",
        "descripcion": "Dosis pendiente para refuerzo.",
        "ubicacion": "Clínica Bienestar",
        "tipo": "Inyección"
      },
    ],
  };

  final Map<String, List<Map<String, String>>> retrasoList = {
    "Primera Fase\n(01/01/2025 - 31/02/2025)": [
      {
        "fecha": "2025-01-01",
        "hora": "10:00 AM",
        "nombre": "Dosis B",
        "descripcion": "Dosis no tomada a tiempo.",
        "ubicacion": "Clínica Los Ángeles",
        "tipo": "Pastilla"
      },
    ],
    "Segunda Fase\n(01/03/2025 - 31/07/2025)": [],
  };

  Map<String, List<Map<String, String>>> currentList = {};

  // Sistema de Puntos y Niveles
  int puntos = 0;
  int nivel = 1;
  double progreso = 0.0;

  // Logros desbloqueados
  final Map<String, bool> logros = {
    'primera_semana': false,
    'primer_mes': false,
    'fase_completa': false,
    'puntual': false,
    'constante': false,
  };

  @override
  void initState() {
    super.initState();
    currentList = registradasList;
    _calcularPuntosYNivel();
  }

  void _calcularPuntosYNivel() {
    // Calcular puntos base por dosis completadas
    puntos = registradasList.values
        .expand((list) => list)
        .length * 100;

    // Bonificación por puntualidad (no tener retrasos)
    if (retrasoList.values.expand((list) => list).isEmpty) {
      puntos += 500;
      logros['puntual'] = true;
    }

    // Calcular nivel basado en puntos
    nivel = (puntos / 1000).floor() + 1;
    progreso = (puntos % 1000) / 1000;

    // Verificar logros
    int totalDosis = registradasList.values
        .expand((list) => list)
        .length;

    if (totalDosis >= 7) logros['primera_semana'] = true;
    if (totalDosis >= 30) logros['primer_mes'] = true;
    if (totalDosis >= 52) logros['fase_completa'] = true;
    if (totalDosis >= 15 && retrasoList.values.expand((list) => list).length <= 2) {
      logros['constante'] = true;
    }
  }

  void updateList(String type) {
    setState(() {
      if (type == "pendientes") {
        currentList = pendientesList;
      } else if (type == "retraso") {
        currentList = retrasoList;
      } else {
        currentList = registradasList;
      }
    });
  }

  Widget buildProgressBar(int total, int actual) {
    double progress = actual / total;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5A7CBF),
                ),
              ),
              Text(
                '$actual de $total dosis',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD94E8F),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 12.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                height: 12.0,
                width: progress * MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5A7CBF), Color(0xFFD94E8F)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF5A7CBF).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String label, IconData icon, Color color, String type) {
    bool isSelected = 
        (type == "pendientes" && currentList == pendientesList) ||
        (type == "retraso" && currentList == retrasoList) ||
        (type == "registradas" && currentList == registradasList);

    return GestureDetector(
      onTap: () => updateList(type),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            colors: isSelected 
                ? [color.withOpacity(0.9), color]
                : [Colors.white, Colors.white],
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? color.withOpacity(0.3) : Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 20,
            ),
            SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .scale(duration: Duration(milliseconds: 200))
      .fade(duration: Duration(milliseconds: 200));
  }

  Widget _buildGamificationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nivel $nivel',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A7CBF),
                      ),
                    ),
                    Text(
                      '$puntos puntos',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD94E8F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFD94E8F),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Siguiente: ${1000 - (puntos % 1000)}',
                        style: const TextStyle(
                          color: Color(0xFFD94E8F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progreso,
                backgroundColor: const Color(0xFF5A7CBF).withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5A7CBF)),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Logros Desbloqueados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A7CBF),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAchievementChip('Primera Semana', logros['primera_semana']!),
                _buildAchievementChip('Primer Mes', logros['primer_mes']!),
                _buildAchievementChip('Fase Completa', logros['fase_completa']!),
                _buildAchievementChip('Siempre Puntual', logros['puntual']!),
                _buildAchievementChip('Constante', logros['constante']!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementChip(String label, bool unlocked) {
    return Chip(
      avatar: Icon(
        unlocked ? Icons.emoji_events : Icons.lock_outline,
        size: 18,
        color: unlocked ? Colors.amber : Colors.grey,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: unlocked ? Colors.black87 : Colors.grey,
          fontWeight: unlocked ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      backgroundColor: unlocked 
          ? Colors.amber.withOpacity(0.1)
          : Colors.grey.withOpacity(0.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    int primeraFaseTotal = 52;
    int segundaFaseTotal = 104;
    int primeraFaseActual =
        registradasList["Primera Fase\n(01/01/2025 - 31/02/2025)"]?.length ?? 0;
    int segundaFaseActual =
        registradasList["Segunda Fase\n(01/03/2025 - 31/07/2025)"]?.length ?? 0;

    return Scaffold(
      backgroundColor: Color(0xFFF9F8EC),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Historial de Dosis",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF5A7CBF),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF5A7CBF), Color(0xFF4E6BA6)],
            ),
          ),
        ),
      ),
      drawer: MenuUsuario(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton("Pendientes", Icons.access_time, Colors.orange, "pendientes"),
                    buildButton("Retraso", Icons.warning, Colors.red, "retraso"),
                    buildButton("Registradas", Icons.check_circle, Colors.green, "registradas"),
                  ],
                ),
                const SizedBox(height: 16),
                _buildGamificationCard(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: currentList.entries.map((entry) {
                String fase = entry.key;
                List<Map<String, String>> registros = entry.value;
                int total = fase.contains("Primera") ? primeraFaseTotal : segundaFaseTotal;
                int actual = fase.contains("Primera") ? primeraFaseActual : segundaFaseActual;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        fase,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Color(0xFF5A7CBF),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    buildProgressBar(total, actual),
                    SizedBox(height: 20.0),
                    ...registros.map((dosis) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: (currentList == pendientesList
                                          ? Colors.orange
                                          : currentList == retrasoList
                                              ? Colors.red
                                              : Colors.green).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      currentList == pendientesList
                                          ? Icons.access_time
                                          : currentList == retrasoList
                                              ? Icons.warning
                                              : Icons.check_circle,
                                      color: currentList == pendientesList
                                          ? Colors.orange
                                          : currentList == retrasoList
                                              ? Colors.red
                                              : Colors.green,
                                      size: 24.0,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              dosis['nombre']!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                                color: Color(0xFF5A7CBF),
                                              ),
                                            ),
                                            Text(
                                              dosis['hora']!,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          dosis['fecha']!,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 16,
                                              color: Color(0xFFD94E8F),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              dosis['ubicacion']!,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xFFD94E8F),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.medical_services_outlined,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              dosis['tipo']!,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate()
                        .fadeIn(duration: Duration(milliseconds: 500))
                        .slideX(begin: 0.2, duration: Duration(milliseconds: 400));
                    }),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
