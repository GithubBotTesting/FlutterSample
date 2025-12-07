import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dormlink/theme.dart';

class PortalRedirectScreen extends StatelessWidget {
  const PortalRedirectScreen({super.key});

  Future<void> _launchPortal() async {
    final Uri url = Uri.parse('https://housing.kfupm.edu.sa');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('University Portal', style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // Icon
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [KFUPMColors.green.withValues(alpha: 0.1), KFUPMColors.forest.withValues(alpha: 0.1)]),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [KFUPMColors.green, KFUPMColors.forest]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school_rounded, size: 56, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            
            Text('Submit Official Request', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'You\'re about to be redirected to the KFUPM Housing Portal to submit your official roommate request.',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            
            // Steps
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Steps to Complete', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  _StepItem(number: 1, text: 'Login with your KFUPM credentials'),
                  const SizedBox(height: 12),
                  _StepItem(number: 2, text: 'Navigate to Housing Services'),
                  const SizedBox(height: 12),
                  _StepItem(number: 3, text: 'Select "Roommate Request"'),
                  const SizedBox(height: 12),
                  _StepItem(number: 4, text: 'Enter your roommate\'s student ID'),
                  const SizedBox(height: 12),
                  _StepItem(number: 5, text: 'Submit and wait for approval'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Info Card
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(color: KFUPMColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(AppRadius.lg)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: KFUPMColors.stone.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(AppRadius.md)),
                    child: Icon(Icons.info_outline_rounded, color: KFUPMColors.stone, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Both students must submit the request for it to be processed.', style: textTheme.bodySmall?.copyWith(color: KFUPMColors.stone, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchPortal,
                icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
                label: const Text('Open KFUPM Portal', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go Back', style: TextStyle(color: colorScheme.onSurfaceVariant)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String text;

  const _StepItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.circle),
          child: Center(child: Text('$number', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: textTheme.bodyMedium)),
      ],
    );
  }
}
