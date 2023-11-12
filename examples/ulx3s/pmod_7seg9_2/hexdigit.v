// ----------------------------------------
// This module converts a input number into
// the corresponding 7Seg digit bit pattern
// for common cathode type 7-seg displays
//
// ----------- 7-seg assignment -----------
//                            a
//       e╶┐┌╴d              ────
//      f╶┐││┌╴c          f │    │
//     g╶┐││││┌╴b           │  g │ b
//   dp╶┐││││││┌╴a    ❯❯     ────
//   8'b00000000          e │    │
//                          │    │ c
//                           ────
//                             d   o dp
// ----------------------------------------
module hexdigit(
  input wire [4:0] in,
  input wire dp,
  output reg [7:0] out
);

always @* begin
  out = 8'b00000000;
  case(in)
    // segment bit: gfedcba
    5'h0: out = {dp, 7'b0111111}; // hex '0' SSD display pattern
    5'h1: out = {dp, 7'b0000110}; // hex '1' SSD display pattern
    5'h2: out = {dp, 7'b1011011}; // hex '2' SSD display pattern
    5'h3: out = {dp, 7'b1001111}; // hex '3' SSD display pattern
    5'h4: out = {dp, 7'b1100110}; // hex '4' SSD display pattern
    5'h5: out = {dp, 7'b1101101}; // hex '5' SSD display pattern
    5'h6: out = {dp, 7'b1111101}; // hex '6' SSD display pattern
    5'h7: out = {dp, 7'b0000111}; // hex '7' SSD display pattern
    5'h8: out = {dp, 7'b1111111}; // hex '8' SSD display pattern
    5'h9: out = {dp, 7'b1101111}; // hex '9' SSD display pattern
    5'ha: out = {dp, 7'b1110111}; // hex 'a' SSD display pattern
    5'hb: out = {dp, 7'b1111100}; // hex 'b' SSD display pattern
    5'hc: out = {dp, 7'b0111001}; // hex 'c' SSD display pattern
    5'hd: out = {dp, 7'b1011110}; // hex 'd' SSD display pattern
    5'he: out = {dp, 7'b1111001}; // hex 'e' SSD display pattern
    5'hf: out = {dp, 7'b1110001}; // hex 'f' SSD display pattern
    // special control 
    5'b10000: out = 8'b11111111; // 16 = all led on
    5'b10001: out = 8'b01000000; // 17 = - (minus sign)
    5'b10010: out = 8'b00001000; // 18 = _ (underscore)
    5'b10011: out = 8'b01101101; // 19 = S
    5'b10100: out = 8'b00000000; // 20 = all led off
    default:  out = 8'b00000000; // default = all led off
  endcase
end
endmodule
