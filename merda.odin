package main

import "core:image"
import "core:image/qoi"
import "core:fmt"
import rl "vendor:raylib"

climber := #load("cimber-wallpaper.qoi", []byte)

main :: proc(){    
    rl.InitWindow(1600, 900, "test")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)

    img, err := image.load_from_bytes(climber)
    if err != nil{
        panic("AAAAAAHHHHH")
    }

    fmt.printf("%#v", img)

    assert(raw_data(img.pixels.buf[:]) != nil, "meu cu, fudeu")

    tex := rl.LoadTextureFromImage(rl.Image{
        width = i32(img.width),
        height = i32(img.height),
        mipmaps = 1,
        format = .UNCOMPRESSED_R8G8B8,
        data = raw_data(img.pixels.buf[:]),
        })

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawTexture(tex, 0, 0, {255, 0, 255, 255})
    }
}

