// ignore: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class GrabarPage extends StatefulWidget {
  const GrabarPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GrabarPageState createState() => _GrabarPageState();
}

class _GrabarPageState extends State<GrabarPage> with SingleTickerProviderStateMixin {
  File? _videoFile;
  VideoPlayerController? _videoController;
  bool _isSliderChanging = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _grabarVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.camera);

    if (video != null) {
      setState(() {
        _videoFile = File(video.path);
      });
      _initializeVideoController();
    }
  }

  Future<void> _cargarVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _videoFile = File(video.path);
      });
      _initializeVideoController();
    }
  }

  void _initializeVideoController() {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(_videoFile!)
      ..addListener(() {
        if (!_isSliderChanging) {
          setState(() {});
        }
      })
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play();
      });
    _videoController!.setLooping(true);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8EC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4E6BA6),
        title: const Text(
          'Grabar y Subir Videos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF4E6BA6).withOpacity(0.1),
                const Color(0xFFF9F8EC),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInstructionsCard(),
                  const SizedBox(height: 30),
                  _buildVideoPreview(),
                  const SizedBox(height: 30),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.tips_and_updates,
              size: 40,
              color: Color(0xFF4E6BA6),
            ),
            const SizedBox(height: 15),
            const Text(
              'Instrucciones',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E6BA6),
              ),
            ),
            const SizedBox(height: 15),
            _buildInstructionStep(
              '1',
              'Presiona "Iniciar Grabación" para comenzar',
              Icons.videocam,
            ),
            _buildInstructionStep(
              '2',
              'Mantén el dispositivo estable durante la grabación',
              Icons.stay_current_portrait,
            ),
            _buildInstructionStep(
              '3',
              'Revisa el video antes de enviarlo',
              Icons.check_circle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF4E6BA6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Icon(icon, color: const Color(0xFF4E6BA6)),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _videoFile == null
            ? Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD34B82),
                      const Color(0xFFD34B82).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.videocam,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'No hay video seleccionado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                  _buildVideoControls(),
                ],
              ),
      ),
    );
  }

  Widget _buildVideoControls() {
    if (_videoController == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: const Color(0xFF4E6BA6),
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    _videoController!.value.isPlaying
                        ? _videoController!.pause()
                        : _videoController!.play();
                  });
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF4E6BA6),
                    inactiveTrackColor: const Color(0xFF4E6BA6).withOpacity(0.2),
                    thumbColor: const Color(0xFF4E6BA6),
                    overlayColor: const Color(0xFF4E6BA6).withOpacity(0.1),
                  ),
                  child: Slider(
                    value: _videoController!.value.position.inSeconds.toDouble(),
                    max: _videoController!.value.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _isSliderChanging = true;
                        _videoController!.seekTo(Duration(seconds: value.toInt()));
                      });
                    },
                    onChangeEnd: (_) {
                      setState(() {
                        _isSliderChanging = false;
                      });
                    },
                  ),
                ),
              ),
              Text(
                '${_formatDuration(_videoController!.value.position)} / ${_formatDuration(_videoController!.value.duration)}',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          onPressed: _grabarVideo,
          icon: Icons.videocam,
          label: 'Iniciar Grabación',
          color: const Color(0xFFD34B82),
        ),
        const SizedBox(height: 15),
        _buildActionButton(
          onPressed: _cargarVideo,
          icon: Icons.upload_file,
          label: 'Enviar Video',
          color: const Color(0xFF9AD1C7),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
