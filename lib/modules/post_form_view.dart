import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'posts_controller.dart';

class PostFormView extends StatefulWidget {
  const PostFormView({super.key});

  @override
  State<PostFormView> createState() => _PostFormViewState();
}

class _PostFormViewState extends State<PostFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final controller = Get.find<PostsController>();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    controller.createPost(title: _titleController.text.trim(), body: _bodyController.text.trim());
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New post')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Enter Title",
                  labelText: 'Title', border: OutlineInputBorder()),
              validator: _required,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(
                hintText: "Enter body",
                  labelText: 'Body', border: OutlineInputBorder()),
              validator: _required,
              minLines: 4,
              maxLines: 8,
            ),
            const SizedBox(height: 24),
            Obx(() => FilledButton(
                  onPressed: controller.isSubmitting.value ? null : _submit,
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Create post'),
                )),
          ],
        ),
      ),
    );
  }
}
