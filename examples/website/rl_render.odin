package main

import clay "../../"
import "core:math"
import "core:strings"
import rl "vendor:raylib"

Raylib_Font :: struct {
    id:   u16,
    font: rl.Font,
}

clay_color_to_rl_color :: proc(color: clay.Color) -> rl.Color {
    return {u8(color.r), u8(color.g), u8(color.b), u8(color.a)}
}

raylib_fonts := [dynamic]Raylib_Font{}

measure_text :: proc "c" (text: clay.Slice, config: ^clay.TextElement, userData: rawptr) -> clay.Dimensions {
    line_width: f32 = 0

    font := raylib_fonts[config.font].font

    for i in 0 ..< text.len {
        glyph_index := text.chars[i] - 32

        glyph := font.glyphs[glyph_index]

        if glyph.advanceX != 0 {
            line_width += f32(glyph.advanceX)
        } else {
            line_width += font.recs[glyph_index].width + f32(glyph.offsetX)
        }
    }

    return {line_width / 2, f32(config.size)}
}

clay_raylib_render :: proc(cmds: clay.Array(clay.Command), allocator := context.temp_allocator) {
    for i in 0 ..< cmds.len {
        cmd := clay.RenderCommandArray_Get(cmds, i)
        bounds := cmd.bounds

        switch cmd.which {
        case .none: // None
        case .text:
            config := cmd.data.text

            text := string(config.content.chars[:config.content.len])

            // Raylib uses C strings instead of Odin strings, so we need to clone
            // Assume this will be freed elsewhere since we default to the temp allocator
            cstr_text := strings.clone_to_cstring(text, allocator)

            font := raylib_fonts[config.font].font
            rl.DrawTextEx(
                font,
                cstr_text,
                bounds.pos,
                f32(config.size),
                f32(config.spacing),
                clay_color_to_rl_color(config.color),
            )
        case .image:
            config := cmd.data.image
            tint := config.bg
            if tint == 0 {
                tint = {255, 255, 255, 255}
            }

            imageTexture := (^rl.Texture2D)(config.image_data)
            rl.DrawTextureEx(
                imageTexture^,
                bounds.pos,
                0,
                bounds.size.x / f32(imageTexture.width),
                clay_color_to_rl_color(tint),
            )
        case .scissor_start:
            rl.BeginScissorMode(
                i32(math.round(bounds.pos.x)),
                i32(math.round(bounds.pos.y)),
                i32(math.round(bounds.size.x)),
                i32(math.round(bounds.size.y)),
            )
        case .scissor_end:
            rl.EndScissorMode()
        case .rectangle:
            config := cmd.data.rectangle
            if config.corner.top_left > 0 {
                radius: f32 = (config.corner.top_left * 2) / min(bounds.size.x, bounds.size.y)
                draw_rect_rounded(bounds.pos.x, bounds.pos.y, bounds.size.x, bounds.size.y, radius, config.bg)
            } else {
                draw_rect(bounds.pos.x, bounds.pos.y, bounds.size.x, bounds.size.y, config.bg)
            }
        case .border:
            config := cmd.data.border
            // Left border
            if config.w.left > 0 {
                draw_rect(
                    bounds.pos.x,
                    bounds.pos.y + config.corner.top_left,
                    f32(config.w.left),
                    bounds.size.y - config.corner.top_left - config.corner.bottom_left,
                    config.color,
                )
            }
            // Right border
            if config.w.right > 0 {
                draw_rect(
                    bounds.pos.x + bounds.size.x - f32(config.w.right),
                    bounds.pos.y + config.corner.top_right,
                    f32(config.w.right),
                    bounds.size.y - config.corner.top_right - config.corner.bottom_right,
                    config.color,
                )
            }
            // Top border
            if config.w.top > 0 {
                draw_rect(
                    bounds.pos.x + config.corner.top_left,
                    bounds.pos.y,
                    bounds.size.x - config.corner.top_left - config.corner.top_right,
                    f32(config.w.top),
                    config.color,
                )
            }
            // Bottom border
            if config.w.bottom > 0 {
                draw_rect(
                    bounds.pos.x + config.corner.bottom_left,
                    bounds.pos.y + bounds.size.y - f32(config.w.bottom),
                    bounds.size.x - config.corner.bottom_left - config.corner.bottom_right,
                    f32(config.w.bottom),
                    config.color,
                )
            }

            // Rounded Borders
            if config.corner.bottom_right > 0 {
                draw_arc(
                    bounds.pos.x + bounds.size.x - config.corner.bottom_right,
                    bounds.pos.y + bounds.size.y - config.corner.bottom_right,
                    config.corner.bottom_right - f32(config.w.bottom),
                    config.corner.bottom_right,
                    0.1,
                    90,
                    config.color,
                )
            }
            if config.corner.bottom_left > 0 {
                draw_arc(
                    bounds.pos.x + config.corner.bottom_left,
                    bounds.pos.y + bounds.size.y - config.corner.bottom_left,
                    config.corner.bottom_left - f32(config.w.bottom),
                    config.corner.bottom_left,
                    90,
                    180,
                    config.color,
                )
            }
            if config.corner.top_left > 0 {
                draw_arc(
                    bounds.pos.x + config.corner.top_left,
                    bounds.pos.y + config.corner.top_left,
                    config.corner.top_left - f32(config.w.top),
                    config.corner.top_left,
                    180,
                    270,
                    config.color,
                )
            }
            if config.corner.top_right > 0 {
                draw_arc(
                    bounds.pos.x + bounds.size.x - config.corner.top_right,
                    bounds.pos.y + config.corner.top_right,
                    config.corner.top_right - f32(config.w.top),
                    config.corner.top_right,
                    270,
                    360,
                    config.color,
                )
            }
        case .custom:
        // Implement custom element rendering here
        }
    }
}

// Helper procs, mainly for repeated conversions

@(private = "file")
draw_arc :: proc(x, y: f32, inner_rad, outer_rad: f32, start_angle, end_angle: f32, color: clay.Color) {
    rl.DrawRing(
        {math.round(x), math.round(y)},
        math.round(inner_rad),
        outer_rad,
        start_angle,
        end_angle,
        10,
        clay_color_to_rl_color(color),
    )
}

@(private = "file")
draw_rect :: proc(x, y, w, h: f32, color: clay.Color) {
    rl.DrawRectangle(
        i32(math.round(x)),
        i32(math.round(y)),
        i32(math.round(w)),
        i32(math.round(h)),
        clay_color_to_rl_color(color),
    )
}

@(private = "file")
draw_rect_rounded :: proc(x, y, w, h: f32, radius: f32, color: clay.Color) {
    rl.DrawRectangleRounded({x, y, w, h}, radius, 8, clay_color_to_rl_color(color))
}

