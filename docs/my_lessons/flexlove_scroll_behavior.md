# FlexLove Scroll Behavior Lessons

## Hiding Scrollbars When Not Needed

To hide scrollbars in FlexLove when they are not required (i.e., when the content fits within the element's bounds), use the `overflow = "auto"` property instead of `overflow = "scroll"`.

- `overflow = "scroll"`: Scrollbars are always visible, even if the content doesn't overflow.
- `overflow = "auto"`: Scrollbars only appear when the content exceeds the element's dimensions.

### Example Usage

```lua
local list = FlexLove.new({
  id = "my_list",
  width = "100%",
  height = "100%",
  overflow = "auto", -- Shows scrollbars only when needed
  flexDirection = "column"
})
```

This is particularly useful for modal windows or lists where the number of items can vary.
