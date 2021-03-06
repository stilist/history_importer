# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Import macOS `.bash_sessions` files
- Import flight tracks
- Import last.fm play history
- Import IRB history data
- Import `less` history data
- Parse [Gyroscope Places](https://gyrosco.pe/places/) data
- Add `activesupport` gem to `Gemfile`

### Changed
- Disable git integration until [git-lfs supports removing old objects](https://github.com/git-lfs/git-lfs/issues/1101)

## [0.2.0] - 2017-01-03
### Added
- Import FaceTime data from macOS
- Import call, Messages, Notes, and voicemail data from iOS
- Import `.ichat` macOS Messages archives (created if ‘Save history when conversations are closed’ is enabled in Messages preferences)
- Document FaceTime and iOS support in `README`

### Changed
- Adjust `import_file` script to support custom filenames for imported files

### Fixed
- Use `HISTORY_DATA_PATH` in Photos importer
- Only run Photos importer if Photos is running (fixes a crash)
- AppleScript wrapper now looks for `*.scpt` instead of `*.sh` (copy-and-paste error)
- Adjust Bundler to install gems to `vendor/bundle`, to avoid permissions issues if the user running the script isn't an administrator
- macOS Messages importer was copying data to `data/messages/Archive/archive` and `data/messages/Attachments/attachments`; the capitalized directory has been removed

## [0.1.0] - 2016-12-30
### Added
- Initial release of scripts

[Unreleased]: https://github.com/stilist/history_importer/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/stilist/history_importer/releases/tag/v0.2.0
[0.1.0]: https://github.com/stilist/history_importer/releases/tag/v0.1.0
