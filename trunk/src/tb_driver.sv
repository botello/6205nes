

`ifndef TB_DRIVER_SV
`define TB_DRIVER_SV

class tb_driver extends component_base;

   protected virtual tb_cpu_if vi;
   mailbox #(request_item) inbox;
   mailbox #(response_item) outbox;

   local int unsigned n_items;

   function new(string name = "tb_driver", component_base parent);
      this.name = name;
      this.parent = parent;
   endfunction

   virtual function void assign_vi(virtual interface tb_cpu_if vi);
      this.vi = vi;
   endfunction

   virtual function void configure();
      n_items = 10;
   endfunction

   virtual task run();
      request_item req;
      response_item rsp;

      init_signals();

      drive_rst(1, 2, 6);

      repeat (n_items) begin
         @(posedge vi.clk);
         inbox.get(req);
         drive_req(req, rsp);
         outbox.put(rsp);
      end
   endtask

   protected task drive_rst(int unsigned n_wait_before, int unsigned n_reset, int unsigned n_wait_after);
      vi.b_rst = 'h1;
      repeat (n_wait_before) @(posedge vi.clk);
      vi.b_rst = 'h0;
      repeat (n_reset) @(posedge vi.clk);
      vi.b_rst = 'h1;
      repeat (n_wait_after) @(posedge vi.clk);
   endtask

   virtual protected task drive_req(request_item req, output response_item rsp);
      // drive item to interface.
      @(posedge vi.clk);

      //drive_nmi(12);

      //@(posedge vi.clk);
      //vi.cpu_data_in = req.inst;

      report_info("RUN", $sformatf("Driven: %s", req.to_string()));
      // copy information to response message.
      rsp = new();
      rsp.id = req.id;
   endtask

   task drive_nmi(int unsigned n_cycles);
      vi.b_nmi = 0;
      repeat (n_cycles) begin
         @(posedge vi.clk);
      end
      vi.b_nmi = 1;
   endtask

   virtual task init_signals();
      vi.b_rst = 'h1;
      vi.b_nmi = 'h1;
      vi.b_irq = 'h1;
      vi.rdy   = 'h1;
   endtask

   virtual function void report();
      report_info("REPORT", $sformatf("Done: driven %p item(s)", n_items));
   endfunction

endclass

`endif

