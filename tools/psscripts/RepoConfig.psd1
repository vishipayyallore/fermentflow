@{
  RepoName = 'fermentflow'

  ExpectedFolders = @(
    '.copilot'
    '.cursor'
    '.claude'
    '.clinerules'
    '.opencode'
    'docs'
    'docs\01-overview'
    'docker'
    'src'
    'tools'
    'tools\psscripts'
    '.github'
    '.github\rules'
    '.cursor\rules'
  )

  YamlCheckRoots = @(
    'docs'
  )

  DisallowInterviewLanguage = $false
}
