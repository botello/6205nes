

`ifndef MEM_REF_BFM_SV
`define MEM_REF_BFM_SV

import tb_pkg::*;

class mem_ref_bfm extends component_base;

   localparam W_ADDR = $bits(t_addr);

   t_data mem [W_ADDR-1:0];

   function new(string name = "mem_ref_bfm");
      this.name = name;
   endfunction

   virtual function void configure();
   endfunction

   virtual function void clear();
      for (int i = 0; i < 2**W_ADDR; i++) begin
         mem[i] = '0;
      end
   endfunction

   virtual function void write(t_addr addr, t_data data);
      mem[addr] = data;
   endfunction

   virtual function t_data read(t_addr addr);
      return mem[addr];
   endfunction

   virtual task run();
   endtask

   virtual function void report();
   endfunction

endclass

`endif

