
FROM COMMAND LINE
-------------------
To compile and run using QuestaSim from command line:
   vsim -c -do questa_all

FROM GRAPHICAL INTERFACE (TRANSCRIPT WINDOW)
----------------------------------------------
Or open QuestaSim's graphical interface and from the Transcript window execute:
   do questa_compile
   do questa_run

To restart simulation and no modifications to the code were made
   restart -f
   run

To restart simulation and modifications were made
   do questa_compile
   restart -f
   run

If compiling fails and you restart to reload simulation it will fail. Try
doing a clean build
   rm -r work
   do questa_all

