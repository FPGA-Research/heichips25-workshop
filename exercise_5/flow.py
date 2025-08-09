import os
from typing import List, Type, Tuple
from librelane.steps import Step
from librelane.steps.step import ViewsUpdate, MetricsUpdate
from librelane.flows import Flow, FlowError
from librelane.flows.classic import Classic
from librelane.state.state import State
from librelane.config.variable import Variable
from librelane.logging import info

def main():

    # Source files
    verilog_files = [
        "counter.sv"
    ]
    
    # Flow configuration
    flow_cfg = {
        # Design
        "DESIGN_NAME"           : "counter",

        # Sources
        "VERILOG_FILES"         : verilog_files,

        # Clock
        "CLOCK_PORT"            : "clk_i",
        "CLOCK_PERIOD"          : 10, # 10ns = 100MHz

        # Die area
        "FP_SIZING"             : "absolute",
        "DIE_AREA"              : [0, 0, 75, 75],
        "PL_TARGET_DENSITY_PCT" : 60,
    }

    flow = Classic(
        flow_cfg,
        design_dir = ".",
        pdk_root   = None,
        pdk        = "ihp-sg13g2",
    )

    flow.start()

if __name__ == "__main__":
    main()
