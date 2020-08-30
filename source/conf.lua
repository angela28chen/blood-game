-- conf: Configuration for game window
function love.conf(t)
	t.title = "Blood Game"
	t.window.width = 512
	t.window.height = 512

	-- For Windows debugging
	t.console = true
end