; Inject html syntax
(nowdoc
  identifier: (heredoc_start) @_id (#eq? @_id "HTML")
  (nowdoc_body) @html
)
