module shift_4(
input clk,
input rst_n,
input in_valid,
input signed [23:0] din_r,
input signed [23:0] din_i,
output signed [23:0] dout_r,
output signed [23:0] dout_i
);
integer i ;
reg [95:0] shift_reg_r ;
reg [95:0] shift_reg_i ;
reg [95:0] tmp_reg_r ;
reg [95:0] tmp_reg_i ;
reg [3:0] counter_4,next_counter_4;
reg valid,next_valid;

assign dout_r    = shift_reg_r[95:72];
assign dout_i    = shift_reg_i[95:72];

always@(*)begin
    next_counter_4 = counter_4 + 3'd1;
    tmp_reg_r = shift_reg_r;
    tmp_reg_i = shift_reg_i;
    next_valid = valid;
end

always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        shift_reg_r <= 0;
        shift_reg_i <= 0;
        counter_4  <= 0;
        valid <= 0;
    end
    else 
    if (in_valid)begin
        counter_4        <= next_counter_4;
        shift_reg_r      <= (tmp_reg_r<<24) + din_r;
        shift_reg_i      <= (tmp_reg_i<<24) + din_i;
        valid            <= in_valid;
    end else if(valid)begin
        counter_4        <= next_counter_4;
        shift_reg_r      <= (tmp_reg_r<<24) + din_r;
        shift_reg_i      <= (tmp_reg_i<<24) + din_i;
        valid            <= next_valid;        
    end
end

endmodule