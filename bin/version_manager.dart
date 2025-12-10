import 'dart:io';

void main(List<String> args) {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) {
    print('Error: pubspec.yaml not found.');
    exit(1);
  }

  final lines = file.readAsLinesSync();
  int versionLineIndex = -1;
  String? currentVersionString;

  for (var i = 0; i < lines.length; i++) {
    if (lines[i].trim().startsWith('version:')) {
      versionLineIndex = i;
      currentVersionString = lines[i].split(':')[1].trim();
      break;
    }
  }

  if (versionLineIndex == -1 || currentVersionString == null) {
    print('Error: Could not find version in pubspec.yaml.');
    exit(1);
  }

  print('Current version: $currentVersionString');

  final versionParts = currentVersionString.split('+');
  final semanticVersion = versionParts[0].split('.').map(int.parse).toList();
  int buildNumber = versionParts.length > 1 ? int.parse(versionParts[1]) : 0;

  String type = args.isNotEmpty ? args[0] : 'build';

  switch (type) {
    case 'major':
      semanticVersion[0]++;
      semanticVersion[1] = 0;
      semanticVersion[2] = 0;
      buildNumber++; // Always bump build number to ensure unique versionCode
      break;
    case 'minor':
      semanticVersion[1]++;
      semanticVersion[2] = 0;
      buildNumber++; // Always bump build number
      break;
    case 'patch':
      semanticVersion[2]++;
      buildNumber++; // Always bump build number
      break;
    case 'build':
      buildNumber++;
      break;
    default:
      print('Unknown type: $type. Use major, minor, patch, or build.');
      exit(1);
  }

  final newVersionString = '${semanticVersion.join('.')}+$buildNumber';
  lines[versionLineIndex] = 'version: $newVersionString';

  file.writeAsStringSync(lines.join('\n'));
  print('Updated version to: $newVersionString');

  // Git operations
  final gitDir = Directory('.git');
  if (gitDir.existsSync()) {
    print('Git repository detected. Executing git commands...');
    _runCommand('git', ['add', '.']);
    _runCommand('git', ['commit', '-m', 'Bump version to $newVersionString']);
    _runCommand('git', ['tag', 'v$newVersionString']);
    print('Git commit and tag created.');

    // Push to remote
    print('Pushing to remote...');
    _runCommand('git', ['push']);
    _runCommand('git', ['push', '--tags']);
    print('Successfully pushed to remote.');
  } else {
    print('No .git directory found. Skipping git commands.');
  }
}

void _runCommand(String executable, List<String> arguments) {
  final result = Process.runSync(executable, arguments);
  if (result.stdout.toString().isNotEmpty) {
    print(result.stdout);
  }
  if (result.exitCode != 0) {
    print('Error running $executable ${arguments.join(' ')}');
    print(result.stderr);
    exit(1); // Stop execution on error
  }
}
