

`ifndef TB_GENERATOR_SV
`define TB_GENERATOR_SV

class tb_generator;

   function new(string name ="tb_generator");
   endfunction

   virtual function void configure();
   endfunction

   virtual task run();
   endtask

endclass

`endif

