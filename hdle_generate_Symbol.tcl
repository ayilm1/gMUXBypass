lappend auto_path "C:/lscc/diamond/3.11_x64/data/script"
package require symbol_generation

set ::bali::Para(MODNAME) gMUXBypass
set ::bali::Para(PROJECT) gMUXBypass
set ::bali::Para(PACKAGE) {"C:/lscc/diamond/3.11_x64/cae_library/vhdl_packages/vdbs"}
set ::bali::Para(PRIMITIVEFILE) {"C:/lscc/diamond/3.11_x64/cae_library/synthesis/verilog/xp2.v"}
set ::bali::Para(FILELIST) {"D:/Dropbox (Personal)/Projects/gMUX Bypass/impl1/source/gMUXBypass.v=work" }
set ::bali::Para(INCLUDEPATH) {}
puts "set parameters done"
::bali::GenerateSymbol
