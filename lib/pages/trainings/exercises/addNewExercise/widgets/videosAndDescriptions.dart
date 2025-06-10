import 'package:flutter/material.dart';
import 'package:muscu/styles/text_styles.dart';

class VideoAndDescriptions extends StatefulWidget {
  final String videoUrl;
  final String description;
  final String note;
  final ValueChanged<String> onVideoUrlChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onNoteChanged;

  const VideoAndDescriptions({
    Key? key,
    required this.videoUrl,
    required this.description,
    required this.note,
    required this.onVideoUrlChanged,
    required this.onDescriptionChanged,
    required this.onNoteChanged,
  }) : super(key: key);

  @override
  State<VideoAndDescriptions> createState() => _VideoAndDescriptionsState();
}

class _VideoAndDescriptionsState extends State<VideoAndDescriptions> {
  late TextEditingController _videoUrlController;
  late TextEditingController _descriptionController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _videoUrlController = TextEditingController(text: widget.videoUrl);
    _descriptionController = TextEditingController(text: widget.description);
    _noteController = TextEditingController(text: widget.note);
  }

  @override
  void dispose() {
    _videoUrlController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Widget buildStyledField({
    required TextEditingController controller,
    required String hint,
    int? maxLines,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall,
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildStyledField(
          controller: _videoUrlController,
          hint: "Entrez le lien de la vidéo",
          maxLines: 1,
          onChanged: widget.onVideoUrlChanged,
        ),
        SizedBox(height: 16),
        buildStyledField(
          controller: _descriptionController,
          hint: "Entrez une description",
          maxLines: 3,
          onChanged: widget.onDescriptionChanged,
        ),
        SizedBox(height: 16),
        buildStyledField(
          controller: _noteController,
          hint: "Ajoutez une note",
          maxLines: 2,
          onChanged: widget.onNoteChanged,
        ),
      ],
    );
  }
}

