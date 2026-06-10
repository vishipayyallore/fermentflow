@{
  RepoName = 'fermentflow'

  ExpectedFolders = @(
    '.copilot'
    '.cursor'
    '.claude'
    'docs'
    'docs\01-overview'
    'docker'
    'src'
    'tools'
    'tools\psscripts'
    '.github'
    '.cursor\rules'
  )

  YamlCheckRoots = @(
    'docs'
  )

  DisallowInterviewLanguage = $false
}
