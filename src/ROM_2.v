module ROM_2(
input clk,
input in_valid,
input rst_n,
output reg [23:0] w_r,
output reg [23:0] w_i,
output reg[1:0] state
);

reg valid,next_valid;
reg [5:0] count,next_count;
reg [1:0] s_count,next_s_count;

always @(*) begin
    state = 2'd0;
    if(in_valid || valid)
    begin 
        next_count = count + 1;
        next_s_count = s_count;
    end
    else begin
        next_count = count;
        next_s_count = s_count;  
    end

    if (count<6'd2) 
        state = 2'd0;
    else if (count >= 6'd2 && s_count < 2'd2)begin
        state = 2'd1;
        next_s_count = s_count + 1;
    end else if (count >= 6'd2 && s_count >= 2'd2)begin
        state = 2'd2;
        next_s_count = s_count + 1;
    end
    case(s_count)
    2'd2: begin
        w_r = 24'b 00000000_00000001_00000000;
        w_i = 24'b 00000000_00000000_00000000;
        end
    2'd3: begin
        w_r = 24'b 00000000_00000000_00000000;
        w_i = 24'b 11111111_11111111_00000000;
        end
    default: begin
        w_r = 24'b 00000000_00000001_00000000;
        w_i = 24'b 00000000_00000000_00000000;
        end
    endcase
end

always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        count <= 0;
        s_count <= 0;
    end
    else begin
        count <= next_count;
        s_count <= next_s_count;
    end
end
endmodule