# =====================================
# COUNTER VERIFICATION SIMULATION
# =====================================

# Create simulation library
if {[file exists work]} {
    vdel -lib work -all
}

vlib work
vmap work work

# Compile RTL
vlog -sv rtl/counter.sv

# Compile Verification Components
vlog -sv tb/monitor/counter_monitor.sv
vlog -sv tb/reference_model/counter_reference_model.sv
vlog -sv tb/scoreboard/counter_scoreboard.sv
vlog -sv tb/assertions/counter_assertions.sv
vlog -sv tb/coverage/counter_coverage.sv
vlog -sv tb/test/counter_test.sv

# Compile Testbench
vlog -sv tb/tb_counter.sv

# Start simulation
vsim -nocvg -assertdebug work.tb_counter

# Add signals to waveform
add wave -r /*/simulation

# Run simulation
run -all

# End