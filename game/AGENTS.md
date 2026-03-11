# Development Strusture Guidelines

First of all, comes scenes. this is the most big unit of the game.
inside of the scenes, could be rendered flexlove ui components directly, or could be rendered the game scene via ecs.

You decide when to use ecs and when not to do that.

under the `docs/` folder, you should put the documentation for external libraries.
under `examples/` folder, you should put the examples usages for the libraries.

There's cute testing suite provided in the game. You can test the game without human in the loop by `love . --cute-headless` command, as long as you write the test cases. Cute will detect and run any tests in the test directory and every subdirectory ending with _tests.lua

whether you need to find out how to use library, you MUST always ask deepwiki mcp first, before going to the library's documentation or examples.

here are deepwiki links for the libraries:
- [Concord](https://deepwiki.com/Keyslam-Group/Concord)
- [FlexLove](https://deepwiki.com/mikefreno/FlexLove)
- [Roomy](https://deepwiki.com/tesselode/roomy)
- [Cute](https://deepwiki.com/gtrogers/Cute)
- [Json.lua](https://deepwiki.com/rxi/json.lua)

Learn your previous relevant lessons first, before asking deepwiki.

Every time you asking deepwiki about something, you MUST write down knowledge you got into docs/my_lessons folder.
ALWAYS ADD task into todo list about writing docs/my_lessons about the knowledge you got.
When you asking deepwiki, you MUST provide some context about the topic, like source code or examples. as example, if you're asking deepwiki on FlexLove about integration with roomy.lua, you need provide code and context about how roomy.lua works, and how you can use roomy.lua to create a scene.
Every time you sucessfully complete the task, you MUST write down the insghts into docs/my_lessons folder.
Task will be completed only when user says "task completed".
