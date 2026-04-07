require('render-markdown').setup({
  -- Don't render Markdown inside code blocks
  nested = false,
  heading = {
    -- Disable marker in sign column
    sign = false,
    icons = false,
    left_pad = 1,
    width = 'full',
    border = true,
    backgrounds = {
        -- 'RenderMarkdownH1Bg',
        'RenderMarkdownH2Bg',
        'RenderMarkdownH3Bg',
        -- 'RenderMarkdownH4Bg',
        'RenderMarkdownH5Bg',
        'RenderMarkdownH6Bg',
    },
    foregrounds = {
        -- 'RenderMarkdownH1',
        'RenderMarkdownH2',
        'RenderMarkdownH3',
        -- 'RenderMarkdownH4',
        'RenderMarkdownH5',
        'RenderMarkdownH6',
    },
  },
  paragraph = {
    left_margin = 2
  },
  code = {
    -- Disable marker in sign column
    sign = false,
    language_pad = 3,
    width = 'block',
    left_margin = 4,
    left_pad = 1,
    right_pad = 1,
    border = 'thin',
    style = 'full'
  },
  bullet = {
    left_pad = 2
  },
  checkbox = {
    left_pad = 2
  },
  pipe_table = {
    cell = 'trimmed'
  },
})
