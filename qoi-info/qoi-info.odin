package main

import "core:fmt"
import "core:image"
import _ "core:image/qoi"
import "core:os"


Image_Info :: struct {
    width   :   int,
	height  :   int,
	channels:   int,
	depth   :   int,
}

info_qoi :: proc(img_qoi_bytes: []byte) -> (img_info :Image_Info, err :image.Error){
    img := image.load_from_bytes(img_qoi_bytes) or_return 
    defer image.destroy(img)

    return Image_Info{
        width = img.width,
        height = img.height,
        channels = img.channels,
        depth = img.depth,
    }, nil
}

print_file_info :: proc(img_path :string){
    fmt.println(img_path, ":")

    img_byte, err_file := os.read_entire_file(img_path, context.allocator)
    if err_file != nil{
        fmt.println(err_file)
        return
    }
    defer delete(img_byte)

    img_info, err_img := info_qoi(img_byte)
    if err_img != nil{
        fmt.println(err_img)
        return
    }
    fmt.printf("%#v\n", img_info)
}

main :: proc() {
    if len(os.args) < 2{
        fmt.println("SEU BURRO")
        os.exit(1)
    }

    for path in os.args[1:]{
        print_file_info(path)
    }
}