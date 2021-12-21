module fifo(
    input [7:0] ascii_code,
    input wrclk,
    input rdclk,
    input rden,
    input rst,
    output reg [7:0] dataout = 0
);

    reg[7:0] buffer[7:0];
    reg [2:0] head = 0, tail = 0;

    reg flag = 1;

    always @ (posedge wrclk) begin
        if (rst) begin
            tail <= 0;
            flag <= 1;
        end
        else begin
            if (ascii_code) begin
                if (flag && (tail + 1) % 8 != head) begin
                    buffer[tail] <= ascii_code;
                    tail <= tail + 1;
                    flag <= 0;
                end
            end
            else begin
                flag <= 1;
            end
        end
    end

    always @ (posedge rdclk) begin
        if (rst) begin
            head <= 0;
        end
        else begin
            if (rden && (head != tail)) begin
                dataout <= buffer[head];
                head <= head + 1;
            end
            else begin
                dataout <= 0;
            end
        end
    end
    
endmodule

