package clay

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "clay.lib"
} else when ODIN_OS == .Linux {
    foreign import lib "clay.linux.a"
} else when ODIN_OS == .Darwin {
    // when ODIN_ARCH == .arm64 {
    foreign import lib "clay.darwin.a"
    // }
    // NOTE: ignored for now
    // else {
    // 	foreign import lib "macos/clay.a"
    // }
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
    foreign import lib "clay.wasm.o"
}

String :: struct {
    static: c.bool,
    len:    c.int32_t,
    chars:  [^]c.char,
}

Slice :: struct {
    len:       c.int32_t,
    chars:     [^]c.char,
    baseChars: [^]c.char,
}

Vector2 :: [2]f32

Dimensions :: Vector2

Arena :: struct {
    nextAllocation: uintptr,
    capacity:       c.size_t,
    memory:         [^]c.char,
}

BBox :: struct {
    pos, size: Vector2,
}

Color :: [4]f32

Corner :: struct {
    top_left, top_right, bottom_left, bottom_right: f32,
}

BorderData :: struct {
    w:     u32,
    color: Color,
}

ElementId :: struct {
    id:       u32,
    offset:   u32,
    baseId:   u32,
    stringId: String,
}

when ODIN_OS == .Windows {
    EnumBackingType :: u32
} else {
    EnumBackingType :: u8
}

RenderCommand :: enum EnumBackingType {
    none,
    rectangle,
    border,
    text,
    image,
    scissor_start,
    scissor_end,
    custom,
}

RectangleElement :: struct {
    color: Color,
}

TextWrapMode :: enum EnumBackingType {
    words,
    newlines,
    none,
}

TextAlignment :: enum EnumBackingType {
    left,
    center,
    right,
}

TextElement :: struct {
    user_data: rawptr,
    color:     Color,
    font:      u16,
    size:      u16,
    spacing:   u16,
    height:    u16,
    wrap:      TextWrapMode,
    align:     TextAlignment,
}

Aspect :: struct {
    aspect: f32,
}

ImageElement :: struct {
    image_data: rawptr,
}

CustomElement :: struct {
    custom_data: rawptr,
}

BorderWidth :: struct {
    left:    u16,
    right:   u16,
    top:     u16,
    bottom:  u16,
    between: u16,
}

BorderElement :: struct {
    color: Color,
    w:     BorderWidth,
}

ClipElement :: struct {
    h:      bool, // clip overflowing elements on the "X" axis
    v:      bool, // clip overflowing elements on the "Y" axis
    offset: Vector2, // offsets the [X,Y] positions of all child elements, primarily for scrolling containers
}

FloatingAttachPointType :: enum EnumBackingType {
    left_top,
    left_center,
    left_bottom,
    center_top,
    center_center,
    center_bottom,
    right_top,
    right_center,
    right_bottom,
}

FloatingAttachPoints :: struct {
    element: FloatingAttachPointType,
    parent:  FloatingAttachPointType,
}

PointerCaptureMode :: enum EnumBackingType {
    capture,
    passthrough,
}

FloatingAttachToElement :: enum EnumBackingType {
    none,
    parent,
    element_with_id,
    root,
}

FloatingClipToElement :: enum EnumBackingType {
    none,
    attached_parent,
}

FloatingElement :: struct {
    offset:  Vector2,
    expand:  Dimensions,
    parent:  u32,
    z:       i16,
    point:   FloatingAttachPoints,
    capture: PointerCaptureMode,
    attach:  FloatingAttachToElement,
    clip:    FloatingClipToElement,
}

TextRender :: struct {
    content: Slice,
    color:   Color,
    font:    u16,
    size:    u16,
    spacing: u16,
    height:  u16,
}

RectangleRender :: struct {
    bg:     Color,
    corner: Corner,
}

ImageRender :: struct {
    bg:         Color,
    corner:     Corner,
    image_data: rawptr,
}

CustomRender :: struct {
    bg:          Color,
    corner:      Corner,
    custom_data: rawptr,
}

BorderRender :: struct {
    color:  Color,
    corner: Corner,
    w:      BorderWidth,
}

RenderCommandData :: struct #raw_union {
    rectangle: RectangleRender,
    text:      TextRender,
    image:     ImageRender,
    custom:    CustomRender,
    border:    BorderRender,
}

Command :: struct {
    bounds:    BBox,
    data:      RenderCommandData,
    user_data: rawptr,
    id:        u32,
    z:         i16,
    which:     RenderCommand,
}

ScrollContainerData :: struct {
    // Note: This is a pointer to the real internal scroll position, mutating it may cause a change in final layout.
    // Intended for use with external functionality that modifies scroll position, such as scroll bars or auto scrolling.
    scrollPosition:            ^Vector2,
    scrollContainerDimensions: Dimensions,
    contentDimensions:         Dimensions,
    config:                    ClipElement,
    // Indicates whether an actual scroll container matched the provided ID or if the default struct was returned.
    found:                     bool,
}

ElementData :: struct {
    bounds: BBox,
    found:  bool,
}

PointerDataInteractionState :: enum EnumBackingType {
    PressedThisFrame,
    Pressed,
    ReleasedThisFrame,
    Released,
}

PointerData :: struct {
    position: Vector2,
    state:    PointerDataInteractionState,
}

SizingType :: enum EnumBackingType {
    fit,
    grow,
    percent,
    fixed,
}

SizingConstraintsMinMax :: struct {
    min: f32,
    max: f32,
}

SizingConstraints :: struct #raw_union {
    min_max: SizingConstraintsMinMax,
    percent: f32,
}

SizingAxis :: struct {
    // Note: `min` is used for CLAY_SIZING_PERCENT, slightly different to clay.h due to lack of C anonymous unions
    constraints: SizingConstraints,
    type:        SizingType,
}

Sizing :: struct {
    w: SizingAxis,
    h: SizingAxis,
}

Padding :: struct {
    left:   u16,
    right:  u16,
    top:    u16,
    bottom: u16,
}

Dir :: enum EnumBackingType {
    h,
    v,
}

AlignH :: enum EnumBackingType {
    left,
    right,
    center,
}

AlignV :: enum EnumBackingType {
    top,
    bottom,
    center,
}

ChildAlignment :: struct {
    x: AlignH,
    y: AlignV,
}

Layout :: struct {
    size:  Sizing,
    pad:   Padding,
    gap:   u16,
    align: ChildAlignment,
    dir:   Dir,
}

Array :: struct($type: typeid) {
    capacity: i32,
    len:      i32,
    internal: [^]type,
}

ElementDeclaration :: struct {
    layout:    Layout,
    bg:        Color,
    corner:    Corner,
    aspect:    Aspect,
    image:     ImageElement,
    floating:  FloatingElement,
    custom:    CustomElement,
    clip:      ClipElement,
    border:    BorderElement,
    user_data: rawptr,
}

ErrorType :: enum EnumBackingType {
    TextMeasurementFunctionNotProvided,
    ArenaCapacityExceeded,
    ElementsCapacityExceeded,
    TextMeasurementCapacityExceeded,
    DuplicateId,
    FloatingContainerParentNotFound,
    PercentageOver1,
    InternalError,
}

ErrorData :: struct {
    error:     ErrorType,
    text:      String,
    user_data: rawptr,
}

ErrorHandler :: struct {
    handler:   proc "c" (errorData: ErrorData),
    user_data: rawptr,
}

Context :: struct {} // opaque structure, only use as a pointer
hover_fn :: #type proc "c" (id: ElementId, pointerData: PointerData, user_data: rawptr)

@(link_prefix = "Clay_", default_calling_convention = "c")
foreign lib {
    MinMemorySize :: proc() -> u32 ---
    CreateArenaWithCapacityAndMemory :: proc(capacity: c.size_t, offset: [^]u8) -> Arena ---
    SetPointerState :: proc(position: Vector2, pointerDown: bool) ---
    Initialize :: proc(arena: Arena, dim: Dimensions, errorHandler: ErrorHandler) -> ^Context ---
    GetCurrentContext :: proc() -> ^Context ---
    SetCurrentContext :: proc(ctx: ^Context) ---
    UpdateScrollContainers :: proc(enableDragScrolling: bool, scrollDelta: Vector2, deltaTime: f32) ---
    SetLayoutDimensions :: proc(dimensions: Dimensions) ---
    BeginLayout :: proc() ---
    EndLayout :: proc() -> Array(Command) ---
    GetElementId :: proc(id: String) -> ElementId ---
    GetElementIdWithIndex :: proc(id: String, index: u32) -> ElementId ---
    GetElementData :: proc(id: ElementId) -> ElementData ---
    Hovered :: proc() -> bool ---
    OnHover :: proc(onHoverFunction: hover_fn, user_data: rawptr) ---
    PointerOver :: proc(id: ElementId) -> bool ---
    GetScrollOffset :: proc() -> Vector2 ---
    GetScrollContainerData :: proc(id: ElementId) -> ScrollContainerData ---
    SetMeasureTextFunction :: proc(measureTextFunction: proc "c" (text: Slice, config: ^TextElement, user_data: rawptr) -> Dimensions, user_data: rawptr) ---
    SetQueryScrollOffsetFunction :: proc(queryScrollOffsetFunction: proc "c" (elementId: u32, user_data: rawptr) -> Vector2, user_data: rawptr) ---
    RenderCommandArray_Get :: proc(#by_ptr array: Array(Command), index: i32) -> ^Command ---
    SetDebugModeEnabled :: proc(enabled: bool) ---
    IsDebugModeEnabled :: proc() -> bool ---
    SetCullingEnabled :: proc(enabled: bool) ---
    GetMaxElementCount :: proc() -> i32 ---
    SetMaxElementCount :: proc(maxElementCount: i32) ---
    GetMaxMeasureTextCacheWordCount :: proc() -> i32 ---
    SetMaxMeasureTextCacheWordCount :: proc(maxMeasureTextCacheWordCount: i32) ---
    ResetMeasureTextCache :: proc() ---
}

ElementType :: enum EnumBackingType {
    none,
    border,
    floating,
    clip,
    aspect,
    image,
    text,
    custom,
    shared,
}


SharedElement :: struct {
    bg:        Color,
    corner:    Corner,
    user_data: rawptr,
}

Element :: struct {
    type:   ElementType,
    config: struct #raw_union {
        text:     ^TextElement,
        aspect:   ^Aspect,
        image:    ^ImageElement,
        floating: ^FloatingElement,
        custom:   ^CustomElement,
        clip:     ^ClipElement,
        border:   ^BorderElement,
        shared:   ^SharedElement,
    },
}

LayoutElement :: struct {
    childrenOrTextContent:     struct #raw_union {
        children:        struct {
            elements: ^i32,
            length:   u16,
        },
        textElementData: rawptr,
        // struct {
        //     text:                String,
        //     preferredDimensions: Dimensions,
        //     elementIndex:        i32,
        //     wrappedLines:        struct {
        //         length:        i32,
        //         internalArray: ^struct {
        //             dimensions: Dimensions,
        //             line:       String,
        //         },
        //     },
        // },
    },
    dimensions, minDimensions: Dimensions,
    layoutConfig:              ^Layout,
    elementConfigs:            struct {
        length:        i32,
        internalArray: ^Element,
    },
    id:                        u32,
    floatingChildrenCount:     u16,
}

LayoutElementHashMapItem :: struct {
    boundingBox:           BBox,
    elementId:             ElementId,
    layoutElement:         ^LayoutElement,
    on_hover:              hover_fn,
    hoverFunctionUserData: rawptr,
    nextIndex:             i32,
    generation:            u32,
    debugData:             rawptr,
}

_LayoutElementTreeRoot :: struct {
    layoutElementIndex: i32,
    parentId:           u32, // This can be zero in the case of the root layout tree
    clipElementId:      u32, // This can be zero if there is no clip element
    zIndex:             i16,
    pointerOffset:      Vector2, // Only used when scroll containers are managed externally
}

@(link_prefix = "Clay_", default_calling_convention = "c", private)
foreign lib {
    _OpenElement :: proc() ---
    _OpenElementWithId :: proc(id: ElementId) ---
    _CloseElement :: proc() ---
    _ConfigureOpenElement :: proc(config: ElementDeclaration) ---
    _HashString :: proc(key: String, seed: u32) -> ElementId ---
    _HashStringWithOffset :: proc(key: String, index: u32, seed: u32) -> ElementId ---
    _OpenTextElement :: proc(text: String, textConfig: ^TextElement) ---
    _StoreTextElementConfig :: proc(config: TextElement) -> ^TextElement ---
    _GetParentElementId :: proc() -> u32 ---
    _GetHashMapItem :: proc(id: u32) -> LayoutElementHashMapItem ---
    _FindTreeRoot :: proc(id: u32) -> ^_LayoutElementTreeRoot ---
}

get_parent :: proc "contextless" () -> u32 {
    return _GetParentElementId()
}

find_parent :: proc "contextless" (id: u32) -> Maybe(ElementId) {
    if root := _FindTreeRoot(id); root != nil {
        return _GetHashMapItem(root.parentId).elementId
    }
    return nil
}

ConfigureOpenElement :: proc "contextless" (config: ElementDeclaration) -> bool {
    _ConfigureOpenElement(config)
    return true
}
open_id :: proc "contextless" (id: ElementId) -> proc "c" (config: ElementDeclaration) {
    _OpenElementWithId(id)
    return _ConfigureOpenElement
}
open_auto :: proc "contextless" () -> proc "c" (config: ElementDeclaration) {
    _OpenElement()
    return _ConfigureOpenElement
}
open :: proc {
    open_id,
    open_auto,
}
close :: proc "contextless" () {
    _CloseElement()
}

@(deferred_none = _CloseElement)
UI_id :: proc "contextless" (id: ElementId) -> proc "contextless" (config: ElementDeclaration) -> bool {
    _OpenElementWithId(id)
    return ConfigureOpenElement
}

@(deferred_none = _CloseElement)
UI_auto :: proc "contextless" () -> proc "contextless" (config: ElementDeclaration) -> bool {
    _OpenElement()
    return ConfigureOpenElement
}

UI :: proc {
    UI_id,
    UI_auto,
}

text :: proc "contextless" ($text: string, config: ^TextElement) {
    wrapped := MakeString(text)
    wrapped.static = true
    _OpenTextElement(wrapped, config)
}

text_dynamic :: proc "contextless" (text: string, config: ^TextElement) {
    _OpenTextElement(MakeString(text), config)
}

text_config :: proc "contextless" (config: TextElement) -> ^TextElement {
    return _StoreTextElementConfig(config)
}

stext :: proc "contextless" ($t: string, config: TextElement) {
    text(t, text_config(config))
}
dtext :: proc "contextless" (t: string, config: TextElement) {
    text_dynamic(t, text_config(config))
}

pad_all :: proc "contextless" (pad: u16) -> Padding {
    return {left = pad, right = pad, top = pad, bottom = pad}
}

border_out :: proc "contextless" (width: u16) -> BorderWidth {
    return {width, width, width, width, 0}
}
bout :: proc "contextless" (c: Color, w: u16) -> BorderElement {
    return {c, border_out(w)}
}

border_all :: proc "contextless" (width: u16) -> BorderWidth {
    return {width, width, width, width, width}
}

corner_all :: proc "contextless" (radius: f32) -> Corner {
    return {radius, radius, radius, radius}
}

fit :: proc "contextless" (sizeMinMax: SizingConstraintsMinMax = {}) -> SizingAxis {
    return {type = .fit, constraints = {min_max = sizeMinMax}}
}

grow :: proc "contextless" (sizeMinMax: SizingConstraintsMinMax = {}) -> SizingAxis {
    return {type = .grow, constraints = {min_max = sizeMinMax}}
}

fixed :: proc "contextless" (size: f32) -> SizingAxis {
    return {type = .fixed, constraints = {min_max = {size, size}}}
}

percent :: proc "contextless" (sizePercent: f32) -> SizingAxis {
    return {type = .percent, constraints = {percent = sizePercent}}
}

MakeString :: proc "contextless" (label: string) -> String {
    return {chars = raw_data(label), len = cast(c.int)len(label)}
}

ID :: proc "contextless" (label: string, index: u32 = 0) -> ElementId {
    return _HashString(MakeString(label), index)
}

ID_LOCAL :: proc "contextless" (label: string, index: u32 = 0) -> ElementId {
    return _HashStringWithOffset(MakeString(label), index, _GetParentElementId())
}

