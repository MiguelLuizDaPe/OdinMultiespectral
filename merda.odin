package main

import "core:mem"
import "core:image"
import "core:image/png"
import "core:fmt"
import rl "vendor:raylib"

climber := #load("cimber-wallpaper.png", []byte)

main :: proc() {
    rl.InitWindow(1600, 900, "test")
    defer rl.CloseWindow()
    rl.SetTargetFPS(60)

    img, err := image.load_from_bytes(climber)
    if err != nil {
        panic("AAAAAAHHHHH")
    }
    defer image.destroy(img)

    fmt.printf("%#v\n", img^)

    pixel_count := img.width * img.height
    rgb8 := make([]u8, pixel_count * 3)
    defer delete(rgb8)

    //o png do cimber é R16G16B16 de int, o img.pixels ta lendo como u8, esse transmute ta arrumando pra ler como u16
    src := (transmute([^]u16)raw_data(img.pixels.buf[:]))[:len(img.pixels.buf[:])/2]
    //esse loop ta apagando as 8 bits da direita
    for i in 0 ..< pixel_count * 3{
        px := src[i]
        rgb8[i] = u8(px >> 8)
    }

    tex := rl.LoadTextureFromImage(rl.Image{
        width   = i32(img.width),
        height  = i32(img.height),
        mipmaps = 1,
        format  = .UNCOMPRESSED_R8G8B8,
        data    = raw_data(rgb8),
    })
    defer rl.UnloadTexture(tex)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawTexture(tex, 0, 0, rl.WHITE)
    }
}