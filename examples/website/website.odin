package main

import "base:runtime"
import "core:c"
import "core:log"

import clay "../../"
import rl "vendor:raylib"

windowWidth: i32 = 1024
windowHeight: i32 = 768

syntaxImage: rl.Texture2D = {}
checkImage1: rl.Texture2D = {}
checkImage2: rl.Texture2D = {}
checkImage3: rl.Texture2D = {}
checkImage4: rl.Texture2D = {}
checkImage5: rl.Texture2D = {}

FONT_ID_BODY_16 :: 0
FONT_ID_TITLE_56 :: 9
FONT_ID_TITLE_52 :: 1
FONT_ID_TITLE_48 :: 2
FONT_ID_TITLE_36 :: 3
FONT_ID_TITLE_32 :: 4
FONT_ID_BODY_36 :: 5
FONT_ID_BODY_30 :: 6
FONT_ID_BODY_28 :: 7
FONT_ID_BODY_24 :: 8

COLOR_LIGHT :: clay.Color{244, 235, 230, 255}
COLOR_LIGHT_HOVER :: clay.Color{224, 215, 210, 255}
COLOR_BUTTON_HOVER :: clay.Color{238, 227, 225, 255}
COLOR_BROWN :: clay.Color{61, 26, 5, 255}
//COLOR_RED :: clay.Color {252, 67, 27, 255}
COLOR_RED :: clay.Color{168, 66, 28, 255}
COLOR_RED_HOVER :: clay.Color{148, 46, 8, 255}
COLOR_ORANGE :: clay.Color{225, 138, 50, 255}
COLOR_BLUE :: clay.Color{111, 173, 162, 255}
COLOR_TEAL :: clay.Color{111, 173, 162, 255}
COLOR_BLUE_DARK :: clay.Color{2, 32, 82, 255}

// Colors for top stripe
COLOR_TOP_BORDER_1 :: clay.Color{168, 66, 28, 255}
COLOR_TOP_BORDER_2 :: clay.Color{223, 110, 44, 255}
COLOR_TOP_BORDER_3 :: clay.Color{225, 138, 50, 255}
COLOR_TOP_BORDER_4 :: clay.Color{236, 189, 80, 255}
COLOR_TOP_BORDER_5 :: clay.Color{240, 213, 137, 255}

COLOR_BLOB_BORDER_1 :: clay.Color{168, 66, 28, 255}
COLOR_BLOB_BORDER_2 :: clay.Color{203, 100, 44, 255}
COLOR_BLOB_BORDER_3 :: clay.Color{225, 138, 50, 255}
COLOR_BLOB_BORDER_4 :: clay.Color{236, 159, 70, 255}
COLOR_BLOB_BORDER_5 :: clay.Color{240, 189, 100, 255}

headerTextConfig := clay.TextElement {
    font  = FONT_ID_BODY_24,
    size  = 24,
    color = {61, 26, 5, 255},
}

border2pxRed := clay.BorderElement {
    w     = {2, 2, 2, 2, 0},
    color = COLOR_RED,
}

LandingPageBlob :: proc(index: u32, size: u16, font: u16, color: clay.Color, $text: string, image: ^rl.Texture2D) {
    if clay.UI(clay.ID("HeroBlob", index))(
    {
        layout = {size = {w = clay.grow({max = 480})}, pad = clay.pad_all(16), gap = 16, align = {y = .center}},
        border = border2pxRed,
        corner = clay.corner_all(10),
    },
    ) {
        if clay.UI(clay.ID("CheckImage", index))(
        {layout = {size = {w = clay.fixed(32)}}, aspect = {1.0}, image = {image_data = image}},
        ) {  }
        clay.text(text, clay.text_config({size = size, font = font, color = color}))
    }
}

LandingPageDesktop :: proc() {
    if clay.UI(clay.ID("LandingPage1Desktop"))(
    {
        layout = {
            size = {w = clay.grow(), h = clay.fit({min = cast(f32)windowHeight - 70})},
            align = {y = .center},
            pad = {left = 50, right = 50},
        },
    },
    ) {
        if clay.UI(clay.ID("LandingPage1"))(
        {
            layout = {size = {clay.grow(), clay.grow()}, align = {y = .center}, pad = clay.pad_all(32), gap = 32},
            border = {COLOR_RED, {left = 2, right = 2}},
        },
        ) {
            if clay.UI(clay.ID("LeftText"))({layout = {size = {w = clay.percent(0.55)}, dir = .v, gap = 8}}) {
                clay.text(
                    "Clay is a flex-box style UI auto layout library in C, with declarative syntax and microsecond performance.",
                    clay.text_config({size = 56, font = FONT_ID_TITLE_56, color = COLOR_RED}),
                )
                if clay.UI()({layout = {size = {w = clay.grow({}), h = clay.fixed(32)}}}) {  }
                clay.text(
                    "Clay is laying out this webpage right now!",
                    clay.text_config({size = 36, font = FONT_ID_TITLE_36, color = COLOR_ORANGE}),
                )
            }
            if clay.UI(clay.ID("HeroImageOuter"))(
            {layout = {dir = .v, size = {w = clay.percent(0.45)}, align = {x = .center}, gap = 16}},
            ) {
                LandingPageBlob(1, 30, FONT_ID_BODY_30, COLOR_BLOB_BORDER_5, "High performance", &checkImage5)
                LandingPageBlob(
                    2,
                    30,
                    FONT_ID_BODY_30,
                    COLOR_BLOB_BORDER_4,
                    "Flexbox-style responsive layout",
                    &checkImage4,
                )
                LandingPageBlob(3, 30, FONT_ID_BODY_30, COLOR_BLOB_BORDER_3, "Declarative syntax", &checkImage3)
                LandingPageBlob(4, 30, FONT_ID_BODY_30, COLOR_BLOB_BORDER_2, "Single .h file for C/C++", &checkImage2)
                LandingPageBlob(5, 30, FONT_ID_BODY_30, COLOR_BLOB_BORDER_1, "Compile to 15kb .wasm", &checkImage1)
            }
        }
    }
}

LandingPageMobile :: proc() {
    if clay.UI(clay.ID("LandingPage1Mobile"))(
    {
        layout = {
            dir = .v,
            size = {w = clay.grow(), h = clay.fit({min = cast(f32)windowHeight - 70})},
            align = {x = .center, y = .center},
            pad = {16, 16, 32, 32},
            gap = 32,
        },
    },
    ) {
        if clay.UI(clay.ID("LeftText"))({layout = {size = {w = clay.grow()}, dir = .v, gap = 8}}) {
            clay.text(
                "Clay is a flex-box style UI auto layout library in C, with declarative syntax and microsecond performance.",
                clay.text_config({size = 48, font = FONT_ID_TITLE_48, color = COLOR_RED}),
            )
            if clay.UI()({layout = {size = {w = clay.grow({}), h = clay.fixed(32)}}}) {  }
            clay.text(
                "Clay is laying out this webpage right now!",
                clay.text_config({size = 32, font = FONT_ID_TITLE_32, color = COLOR_ORANGE}),
            )
        }
        if clay.UI(clay.ID("HeroImageOuter"))(
        {layout = {dir = .v, size = {w = clay.grow()}, align = {x = .center}, gap = 16}},
        ) {
            LandingPageBlob(1, 24, FONT_ID_BODY_24, COLOR_BLOB_BORDER_5, "High performance", &checkImage5)
            LandingPageBlob(
                2,
                24,
                FONT_ID_BODY_24,
                COLOR_BLOB_BORDER_4,
                "Flexbox-style responsive layout",
                &checkImage4,
            )
            LandingPageBlob(3, 24, FONT_ID_BODY_24, COLOR_BLOB_BORDER_3, "Declarative syntax", &checkImage3)
            LandingPageBlob(4, 24, FONT_ID_BODY_24, COLOR_BLOB_BORDER_2, "Single .h file for C/C++", &checkImage2)
            LandingPageBlob(5, 24, FONT_ID_BODY_24, COLOR_BLOB_BORDER_1, "Compile to 15kb .wasm", &checkImage1)
        }
    }
}

FeatureBlocks :: proc(widthSizing: clay.SizingAxis, outerpad: u16) {
    textConfig := clay.text_config({size = 24, font = FONT_ID_BODY_24, color = COLOR_RED})
    if clay.UI(clay.ID("HFileBoxOuter"))(
    {
        layout = {
            dir = .v,
            size = {w = widthSizing},
            align = {y = .center},
            pad = {outerpad, outerpad, 32, 32},
            gap = 8,
        },
    },
    ) {
        if clay.UI(clay.ID("HFileIncludeOuter"))(
        {layout = {pad = {8, 8, 4, 4}}, bg = COLOR_RED, corner = clay.corner_all(8)},
        ) {
            clay.text("#include clay.h", clay.text_config({size = 24, font = FONT_ID_BODY_24, color = COLOR_LIGHT}))
        }
        clay.text("~2000 lines of C99.", textConfig)
        clay.text("Zero dependencies, including no C standard library.", textConfig)
    }
    if clay.UI(clay.ID("BringYourOwnRendererOuter"))(
    {
        layout = {
            dir = .v,
            size = {w = widthSizing},
            align = {y = .center},
            pad = {outerpad, outerpad, 32, 32},
            gap = 8,
        },
    },
    ) {
        clay.text("Renderer agnostic.", clay.text_config({font = FONT_ID_BODY_24, size = 24, color = COLOR_ORANGE}))
        clay.text("Layout with clay, then render with rl, WebGL Canvas or even as HTML.", textConfig)
        clay.text("Flexible output for easy compositing in your custom engine or environment.", textConfig)
    }
}

FeatureBlocksDesktop :: proc() {
    if clay.UI(clay.ID("FeatureBlocksOuter"))({layout = {size = {w = clay.grow({})}}}) {
        if clay.UI(clay.ID("FeatureBlocksInner"))(
        {layout = {size = {w = clay.grow()}, align = {y = .center}}, border = {w = {between = 2}, color = COLOR_RED}},
        ) {
            FeatureBlocks(clay.percent(0.5), 50)
        }
    }
}

FeatureBlocksMobile :: proc() {
    if clay.UI(clay.ID("FeatureBlocksInner"))(
    {layout = {dir = .v, size = {w = clay.grow()}}, border = {w = {between = 2}, color = COLOR_RED}},
    ) {
        FeatureBlocks(clay.grow({}), 16)
    }
}

DeclarativeSyntaxPage :: proc(titleTextConfig: clay.TextElement, widthSizing: clay.SizingAxis) {
    if clay.UI(clay.ID("SyntaxPageLeftText"))({layout = {size = {w = widthSizing}, dir = .v, gap = 8}}) {
        clay.text("Declarative Syntax", clay.text_config(titleTextConfig))
        if clay.UI(clay.ID("SyntaxSpacer"))({layout = {size = {w = clay.grow({max = 16})}}}) {  }
        clay.text(
            "Flexible and readable declarative syntax with nested UI element hierarchies.",
            clay.text_config({size = 28, font = FONT_ID_BODY_28, color = COLOR_RED}),
        )
        clay.text(
            "Mix elements with standard C code like loops, conditionals and functions.",
            clay.text_config({size = 28, font = FONT_ID_BODY_28, color = COLOR_RED}),
        )
        clay.text(
            "Create your own library of re-usable components from UI primitives like text, images and rectangles.",
            clay.text_config({size = 28, font = FONT_ID_BODY_28, color = COLOR_RED}),
        )
    }
    if clay.UI(clay.ID("SyntaxPageRightImage"))({layout = {size = {w = widthSizing}, align = {x = .center}}}) {
        if clay.UI(clay.ID("SyntaxPageRightImageInner"))(
        {
            layout = {size = {w = clay.grow({max = 568})}},
            aspect = {1136.0 / 1194.0},
            image = {image_data = &syntaxImage},
        },
        ) {  }
    }
}

DeclarativeSyntaxPageDesktop :: proc() {
    if clay.UI(clay.ID("SyntaxPageDesktop"))(
    {
        layout = {
            size = {clay.grow(), clay.fit({min = cast(f32)windowHeight - 50})},
            align = {y = .center},
            pad = {left = 50, right = 50},
        },
    },
    ) {
        if clay.UI(clay.ID("SyntaxPage"))(
        {
            layout = {size = {clay.grow(), clay.grow()}, align = {y = .center}, pad = clay.pad_all(32), gap = 32},
            border = border2pxRed,
        },
        ) {
            DeclarativeSyntaxPage({size = 52, font = FONT_ID_TITLE_52, color = COLOR_RED}, clay.percent(0.5))
        }
    }
}

DeclarativeSyntaxPageMobile :: proc() {
    if clay.UI(clay.ID("SyntaxPageMobile"))(
    {
        layout = {
            dir = .v,
            size = {clay.grow(), clay.fit({min = cast(f32)windowHeight - 50})},
            align = {x = .center, y = .center},
            pad = {16, 16, 32, 32},
            gap = 16,
        },
    },
    ) {
        DeclarativeSyntaxPage({size = 48, font = FONT_ID_TITLE_48, color = COLOR_RED}, clay.grow({}))
    }
}

ColorLerp :: proc(a: clay.Color, b: clay.Color, amount: f32) -> clay.Color {
    return clay.Color {
        a.r + (b.r - a.r) * amount,
        a.g + (b.g - a.g) * amount,
        a.b + (b.b - a.b) * amount,
        a.a + (b.a - a.a) * amount,
    }
}

LOREM_IPSUM_TEXT :: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

HighPerformancePage :: proc(lerpValue: f32, titleTextConfig: clay.TextElement, widthSizing: clay.SizingAxis) {
    if clay.UI(clay.ID("PerformanceLeftText"))({layout = {size = {w = widthSizing}, dir = .v, gap = 8}}) {
        clay.text("High Performance", clay.text_config(titleTextConfig))
        if clay.UI()({layout = {size = {w = clay.grow({max = 16})}}}) {  }
        clay.text(
            "Fast enough to recompute your entire UI every frame.",
            clay.text_config({size = 28, font = FONT_ID_BODY_36, color = COLOR_LIGHT}),
        )
        clay.text(
            "Small memory footprint (3.5mb default) with static allocation & reuse. No malloc / free.",
            clay.text_config({size = 28, font = FONT_ID_BODY_36, color = COLOR_LIGHT}),
        )
        clay.text(
            "Simplify animations and reactive UI design by avoiding the standard performance hacks.",
            clay.text_config({size = 28, font = FONT_ID_BODY_36, color = COLOR_LIGHT}),
        )
    }
    if clay.UI(clay.ID("PerformanceRightImageOuter"))({layout = {size = {w = widthSizing}, align = {x = .center}}}) {
        if clay.UI(clay.ID("PerformanceRightBorder"))(
        {layout = {size = {clay.grow(), clay.fixed(400)}}, border = {COLOR_LIGHT, {2, 2, 2, 2, 2}}},
        ) {
            if clay.UI(clay.ID("AnimationDemoContainerLeft"))(
            {
                layout = {
                    size = {clay.percent(0.35 + 0.3 * lerpValue), clay.grow()},
                    align = {y = .center},
                    pad = clay.pad_all(16),
                },
                bg = ColorLerp(COLOR_RED, COLOR_ORANGE, lerpValue),
            },
            ) {
                clay.text(LOREM_IPSUM_TEXT, clay.text_config({size = 16, font = FONT_ID_BODY_16, color = COLOR_LIGHT}))
            }
            if clay.UI(clay.ID("AnimationDemoContainerRight"))(
            {
                layout = {size = {clay.grow(), clay.grow()}, align = {y = .center}, pad = clay.pad_all(16)},
                bg = ColorLerp(COLOR_ORANGE, COLOR_RED, lerpValue),
            },
            ) {
                clay.text(LOREM_IPSUM_TEXT, clay.text_config({size = 16, font = FONT_ID_BODY_16, color = COLOR_LIGHT}))
            }
        }
    }
}

HighPerformancePageDesktop :: proc(lerpValue: f32) {
    if clay.UI(clay.ID("PerformanceDesktop"))(
    {
        layout = {
            size = {clay.grow(), clay.fit({min = cast(f32)windowHeight - 50})},
            align = {y = .center},
            pad = {82, 82, 32, 32},
            gap = 64,
        },
        bg = COLOR_RED,
    },
    ) {
        HighPerformancePage(lerpValue, {size = 52, font = FONT_ID_TITLE_52, color = COLOR_LIGHT}, clay.percent(0.5))
    }
}

HighPerformancePageMobile :: proc(lerpValue: f32) {
    if clay.UI(clay.ID("PerformanceMobile"))(
    {
        layout = {
            dir = .v,
            size = {clay.grow(), clay.fit({min = cast(f32)windowHeight - 50})},
            align = {x = .center, y = .center},
            pad = {16, 16, 32, 32},
            gap = 32,
        },
        bg = COLOR_RED,
    },
    ) {
        HighPerformancePage(lerpValue, {size = 48, font = FONT_ID_TITLE_48, color = COLOR_LIGHT}, clay.grow({}))
    }
}

RendererButtonActive :: proc(index: i32, $text: string) {
    if clay.UI()(
    {layout = {size = {w = clay.fixed(300)}, pad = clay.pad_all(16)}, bg = COLOR_RED, corner = clay.corner_all(10)},
    ) {
        clay.text(text, clay.text_config({size = 28, font = FONT_ID_BODY_28, color = COLOR_LIGHT}))
    }
}

RendererButtonInactive :: proc(index: u32, $text: string) {
    if clay.UI()({border = border2pxRed}) {
        if clay.UI(clay.ID("RendererButtonInactiveInner", index))(
        {
            layout = {size = {w = clay.fixed(300)}, pad = clay.pad_all(16)},
            bg = COLOR_LIGHT,
            corner = clay.corner_all(10),
        },
        ) {
            clay.text(text, clay.text_config({size = 28, font = FONT_ID_BODY_28, color = COLOR_RED}))
        }
    }
}

RendererPage :: proc(titleTextConfig: clay.TextElement, widthSizing: clay.SizingAxis) {
    if clay.UI(clay.ID("RendererLeftText"))({layout = {size = {w = widthSizing}, dir = .v, gap = 8}}) {
        clay.text("Renderer & Platform Agnostic", clay.text_config(titleTextConfig))
        if clay.UI()({layout = {size = {w = clay.grow({max = 16})}}}) {  }
        clay.text(
            "Clay outputs a sorted array of primitive render commands, such as RECTANGLE, TEXT or IMAGE.",
            clay.text_config({size = 28, font = FONT_ID_BODY_36, color = COLOR_RED}),
        )
        clay.text(
            "Write your own renderer in a few hundred lines of code, or use the provided examples for rl, WebGL canvas and more.",
            clay.text_config({size = 28, font = FONT_ID_BODY_36, color = COLOR_RED}),
        )
        clay.text(
            "There's even an HTML renderer - you're looking at it right now!",
            clay.text_config({size = 28, font = FONT_ID_BODY_36, color = COLOR_RED}),
        )
    }
    if clay.UI(clay.ID("RendererRightText"))(
    {layout = {size = {w = widthSizing}, align = {x = .center}, dir = .v, gap = 16}},
    ) {
        clay.text(
            "Try changing renderer!",
            clay.text_config({size = 36, font = FONT_ID_BODY_36, color = COLOR_ORANGE}),
        )
        if clay.UI()({layout = {size = {w = clay.grow({max = 32})}}}) {  }
        RendererButtonActive(0, "rl Renderer")
    }
}

RendererPageDesktop :: proc() {
    if clay.UI(clay.ID("RendererPageDesktop"))(
    {
        layout = {
            size = {clay.grow(), clay.fit({min = cast(f32)windowHeight - 50})},
            align = {y = .center},
            pad = {left = 50, right = 50},
        },
    },
    ) {
        if clay.UI(clay.ID("RendererPage"))(
        {
            layout = {size = {clay.grow(), clay.grow()}, align = {y = .center}, pad = clay.pad_all(32), gap = 32},
            border = {COLOR_RED, {left = 2, right = 2}},
        },
        ) {
            RendererPage({size = 52, font = FONT_ID_TITLE_52, color = COLOR_RED}, clay.percent(0.5))
        }
    }
}

RendererPageMobile :: proc() {
    if clay.UI(clay.ID("RendererMobile"))(
    {
        layout = {
            dir = .v,
            size = {clay.grow(), clay.fit({min = cast(f32)windowHeight - 50})},
            align = {x = .center, y = .center},
            pad = {16, 16, 32, 32},
            gap = 32,
        },
        bg = COLOR_LIGHT,
    },
    ) {
        RendererPage({size = 48, font = FONT_ID_TITLE_48, color = COLOR_RED}, clay.grow({}))
    }
}

ScrollbarData :: struct {
    clickOrigin:    clay.Vector2,
    positionOrigin: clay.Vector2,
    mouseDown:      bool,
}

scrollbarData := ScrollbarData{}
animationLerpValue: f32 = -1.0

createLayout :: proc(lerpValue: f32) -> clay.Array(clay.Command) {
    mobileScreen := windowWidth < 750
    clay.BeginLayout()
    if clay.UI(clay.ID("OuterContainer"))({layout = {dir = .v, size = {clay.grow(), clay.grow()}}, bg = COLOR_LIGHT}) {
        if clay.UI(clay.ID("Header"))(
        {
            layout = {
                size = {clay.grow(), clay.fixed(50)},
                align = {y = .center},
                gap = 24,
                pad = {left = 32, right = 32},
            },
        },
        ) {
            clay.text("Clay", &headerTextConfig)
            if clay.UI()({layout = {size = {w = clay.grow()}}}) {  }

            if (!mobileScreen) {
                if clay.UI(clay.ID("LinkExamplesOuter"))({bg = {0, 0, 0, 0}}) {
                    clay.text(
                        "Examples",
                        clay.text_config({font = FONT_ID_BODY_24, size = 24, color = {61, 26, 5, 255}}),
                    )
                }
                if clay.UI(clay.ID("LinkDocsOuter"))({bg = {0, 0, 0, 0}}) {
                    clay.text("Docs", clay.text_config({font = FONT_ID_BODY_24, size = 24, color = {61, 26, 5, 255}}))
                }
            }
            if clay.UI(clay.ID("LinkGithubOuter"))(
            {
                layout = {pad = {16, 16, 6, 6}},
                border = border2pxRed,
                bg = clay.Hovered() ? COLOR_LIGHT_HOVER : COLOR_LIGHT,
                corner = clay.corner_all(10),
            },
            ) {
                clay.text("Github", clay.text_config({font = FONT_ID_BODY_24, size = 24, color = {61, 26, 5, 255}}))
            }
        }
        if clay.UI(clay.ID("TopBorder1"))(
        {layout = {size = {clay.grow(), clay.fixed(4)}}, bg = COLOR_TOP_BORDER_5},
        ) {  }
        if clay.UI(clay.ID("TopBorder2"))(
        {layout = {size = {clay.grow(), clay.fixed(4)}}, bg = COLOR_TOP_BORDER_4},
        ) {  }
        if clay.UI(clay.ID("TopBorder3"))(
        {layout = {size = {clay.grow(), clay.fixed(4)}}, bg = COLOR_TOP_BORDER_3},
        ) {  }
        if clay.UI(clay.ID("TopBorder4"))(
        {layout = {size = {clay.grow(), clay.fixed(4)}}, bg = COLOR_TOP_BORDER_2},
        ) {  }
        if clay.UI(clay.ID("TopBorder5"))(
        {layout = {size = {clay.grow(), clay.fixed(4)}}, bg = COLOR_TOP_BORDER_1},
        ) {  }
        if clay.UI(clay.ID("ScrollContainerBackgroundRectangle"))(
        {
            clip = {v = true, offset = clay.GetScrollOffset()},
            layout = {size = {clay.grow(), clay.grow()}, dir = .v},
            bg = COLOR_LIGHT,
            border = {COLOR_RED, {between = 2}},
        },
        ) {
            if (!mobileScreen) {
                LandingPageDesktop()
                FeatureBlocksDesktop()
                DeclarativeSyntaxPageDesktop()
                HighPerformancePageDesktop(lerpValue)
                RendererPageDesktop()
            } else {
                LandingPageMobile()
                FeatureBlocksMobile()
                DeclarativeSyntaxPageMobile()
                HighPerformancePageMobile(lerpValue)
                RendererPageMobile()
            }
        }
    }
    return clay.EndLayout()
}

loadFont :: proc(font: u16, size: u16, path: cstring) {
    assign_at(&raylib_fonts, font, Raylib_Font{font = rl.LoadFontEx(path, cast(i32)size * 2, nil, 0), id = font})
    rl.SetTextureFilter(raylib_fonts[font].font.texture, rl.TextureFilter.TRILINEAR)
}
ContextWrapper :: struct {
    ctx: runtime.Context,
}
errorHandler :: proc "c" (raw: clay.ErrorData) {
    context = (cast(^ContextWrapper)raw.user_data).ctx
    log.error("[clay]", raw.text)
}

main :: proc() {
    minMemorySize: c.size_t = cast(c.size_t)clay.MinMemorySize()
    memory := make([^]u8, minMemorySize)
    arena: clay.Arena = clay.CreateArenaWithCapacityAndMemory(minMemorySize, memory)
    context.logger = log.create_console_logger()
    clay.Initialize(
        arena,
        {cast(f32)rl.GetScreenWidth(), cast(f32)rl.GetScreenHeight()},
        {handler = errorHandler, user_data = &ContextWrapper{context}},
    )
    clay.SetMeasureTextFunction(measure_text, nil)

    rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .MSAA_4X_HINT, .WINDOW_HIGHDPI})
    rl.InitWindow(windowWidth, windowHeight, "rl Odin Example")
    rl.SetTargetFPS(rl.GetMonitorRefreshRate(0))
    loadFont(FONT_ID_TITLE_56, 56, "resources/Calistoga-Regular.ttf")
    loadFont(FONT_ID_TITLE_52, 52, "resources/Calistoga-Regular.ttf")
    loadFont(FONT_ID_TITLE_48, 48, "resources/Calistoga-Regular.ttf")
    loadFont(FONT_ID_TITLE_36, 36, "resources/Calistoga-Regular.ttf")
    loadFont(FONT_ID_TITLE_32, 32, "resources/Calistoga-Regular.ttf")
    loadFont(FONT_ID_BODY_36, 36, "resources/Quicksand-Semibold.ttf")
    loadFont(FONT_ID_BODY_30, 30, "resources/Quicksand-Semibold.ttf")
    loadFont(FONT_ID_BODY_28, 28, "resources/Quicksand-Semibold.ttf")
    loadFont(FONT_ID_BODY_24, 24, "resources/Quicksand-Semibold.ttf")
    loadFont(FONT_ID_BODY_16, 16, "resources/Quicksand-Semibold.ttf")

    syntaxImage = rl.LoadTexture("resources/declarative.png")
    checkImage1 = rl.LoadTexture("resources/check_1.png")
    checkImage2 = rl.LoadTexture("resources/check_2.png")
    checkImage3 = rl.LoadTexture("resources/check_3.png")
    checkImage4 = rl.LoadTexture("resources/check_4.png")
    checkImage5 = rl.LoadTexture("resources/check_5.png")

    debugModeEnabled: bool = false

    for !rl.WindowShouldClose() {
        defer free_all(context.temp_allocator)

        animationLerpValue += rl.GetFrameTime()
        if animationLerpValue > 1 {
            animationLerpValue = animationLerpValue - 2
        }
        windowWidth = rl.GetScreenWidth()
        windowHeight = rl.GetScreenHeight()
        if (rl.IsKeyPressed(.D)) {
            debugModeEnabled = !debugModeEnabled
            clay.SetDebugModeEnabled(debugModeEnabled)
        }
        clay.SetPointerState(rl.GetMousePosition(), rl.IsMouseButtonDown(rl.MouseButton.LEFT))
        clay.UpdateScrollContainers(false, rl.GetMouseWheelMoveV(), rl.GetFrameTime())
        clay.SetLayoutDimensions({cast(f32)rl.GetScreenWidth(), cast(f32)rl.GetScreenHeight()})
        rl.BeginDrawing()
        clay_raylib_render(createLayout(animationLerpValue < 0 ? (animationLerpValue + 1) : (1 - animationLerpValue)))
        rl.EndDrawing()
    }
}

