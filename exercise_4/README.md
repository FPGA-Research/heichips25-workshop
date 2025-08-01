# Exercise 4 - Using Macros

Hard macros are pre-implemented IPs with a dedicated function that you can use in your design. You can implement your own macros, or use the ones provided by the PDK such as IO cells, SRAM macros, analog IPs maybe, etc.

This exercise shows you how to create your own macro and subsequently use it in another design.

## 4.1 - Creating a Macro

Change your current working directory to `counter_8bit`:

```
cd counter_8bit
```

First we need to decide on an integration method for the macro.
We need to ensure that we can connect the macro to the top-level PDN (Power Distribution Network). As we have only a single voltage domain this should be quite simple: we only have to care for the VPWR and VGND pins.

The IHP Open PDK has five metal layers dedicated for routing (Metal1-Metal5) and two top metal layers (TopMetal1 and TopMetal2).

By default LibreLane will create horizontal power straps using TopMetal1 and vertical power straps using TopMetal2. You can see them here in blue and red:

![OpenROAD GUI](img/openroad_1.png)

To integrate the macro into a top-level design we need to choose one of several methods. You can read more about them here: [Power Distribution Networks](https://librelane.readthedocs.io/en/latest/usage/pdn.html)

**Hierarchical Method**: By using this method, each macro uses one less metal layer than the previous level. Since we only have our top-level and the macro, this means that we only use up to TopMetal1 for the macro. The macro is then integrated by placing vertical TopMetal2 straps across the macro in the top-level and dropping vias where TopMetal1 and TopMetal2 overlap (for the correct net).

**Ring Method**: This method creates a power ring around your macro consisting of TopMetal1 and TopMetal2. With this method you don't loose any metal layers in your macro, however, it takes more area to implement the ring method.

You need to choose one of the two methods. 3... 2... 1... okay and off you go.

If you chose the hierarchical method you need to restrict the maximum routing layer to TopMetal1 and set the PDN to only use a single layer (TopMetal1).

```yaml
# Don't use TopMetal2 layer
PDN_MULTILAYER: false
RT_MAX_LAYER: TopMetal1
```

If you chose the ring method, you only need to enable the core ring:

```yaml
# Enable the core ring
FP_PDN_CORE_RING: true
```

Finally, implement the design:

```
librelane --pdk ihp-sg13g2 config.yaml
```

Great! Once that is done copy the `final/` directory with all its contents from the last run directory (`runs/<timestamp>/final/`) into the `counter_8bit` folder (`counter_8bit/final/`).

You've created your first macro.

## 4.2 - Integrating a Macro

The top-level design is a 32-bit counter made up of four 8-bit counters, our macro. How do we integrate the macro instances?

As it will, LibreLane has a guide handy: [Using Macros](https://librelane.readthedocs.io/en/latest/usage/using_macros.html)

Most importantly, we need to tell LibreLane where to find the macro. Unfortunately, the macro consists of a number of files, which we need to specify individually:

```yaml
MACROS:
  counter_8bit:
    gds:
      - dir::counter_8bit/final/gds/counter_8bit.gds
    lef:
      - dir::counter_8bit/final/lef/counter_8bit.lef
    nl:
      - dir::counter_8bit/final/nl/counter_8bit.nl.v
    lib:
      nom_typ_1p20V_25C:
        - dir::counter_8bit/final/lib/nom_typ_1p20V_25C/counter_8bit__nom_typ_1p20V_25C.lib
      nom_fast_1p32V_m40C:
        - dir::counter_8bit/final/lib/nom_fast_1p32V_m40C/counter_8bit__nom_fast_1p32V_m40C.lib
      nom_slow_1p08V_125C:
        - dir::counter_8bit/final/lib/nom_slow_1p08V_125C/counter_8bit__nom_slow_1p08V_125C.lib
    spef:
      nom:
        - dir::counter_8bit/final/spef/nom/counter_8bit.nom.spef
    instances:
      counter_0:
        location: [20, 20]
        orientation: N
      counter_1:
        location: [20, 105]
        orientation: N
      counter_2:
        location: [105, 20]
        orientation: N
      counter_3:
        location: [105, 105]
        orientation: N
```

The instances key specifies the instances of the macro in the top-level design with their coordinates and orientation.

We also have to tell LibreLane that the `VPWR` and `VGND` pins of the macros should be connected to the `VPWR` and `VGND` nets at the top-level:

```
PDN_MACRO_CONNECTIONS:
  - "counter_0 VPWR VGND VPWR VGND"
  - "counter_1 VPWR VGND VPWR VGND"
  - "counter_2 VPWR VGND VPWR VGND"
  - "counter_3 VPWR VGND VPWR VGND"
```

If you run the flow now, you will probably get an error during PDN generation. The issue is that the pitch between the PDN straps at the top-level is too large to reliable connect the macros.

Therefore, we simply reduce the PDN pitch:

```
FP_PDN_VPITCH: 20
FP_PDN_HPITCH: 20
```

Other noteworthy variables are `FP_PDN_VWIDTH`/`FP_PDN_HWIDTH` and `FP_PDN_VSPACING`/`FP_PDN_HSPACING`.

Now, let's run the flow at the top-level (in `exercise_4/`):

```
librelane --pdk ihp-sg13g2 config.yaml
```

LibreLane should complete successfully and you should be presented with one of the two results:

| Hierarchical Method | Ring Method |
|--------------------|--------------------|
| ![OpenROAD GUI](img/openroad_3.png) | ![OpenROAD GUI](img/openroad_2.png) |

## Bonus - IHP SRAM

As a bonus task, you can try to integrate an SRAM macro from the IHP PDK. Why use an SRAM? For large memories, SRAM is much more efficient area-wise than a memory made of flip-flops or latches.

> [!NOTE]  
> Remember, the PDK is stored under `~/.ciel`. Take a look at the `libs.ref/sg13g2_sram/` directory for an overview of the available SRAM macros.

Here I chose the [RM_IHPSG13_1P_1024x8_c2_bm_bist](https://github.com/IHP-GmbH/IHP-Open-PDK/blob/main/ihp-sg13g2/libs.ref/sg13g2_sram/doc/RM_IHPSG13_1P_1024x8_c2_bm_bist.txt), an 8-bit wide SRAM with 1024 words, for you.

You can use this configuration as reference:

```
MACROS:
  RM_IHPSG13_1P_1024x8_c2_bm_bist:
    gds:
      - pdk_dir::libs.ref/sg13g2_sram/gds/RM_IHPSG13_1P_1024x8_c2_bm_bist.gds
    lef:
      - pdk_dir::libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_1024x8_c2_bm_bist.lef
    nl:
      - pdk_dir::libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x8_c2_bm_bist.v
    lib:
      nom_typ_1p20V_25C:
        - pdk_dir::libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_1024x8_c2_bm_bist_typ_1p20V_25C.lib
      nom_fast_1p32V_m40C:
        - pdk_dir::libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_1024x8_c2_bm_bist_fast_1p32V_m55C.lib
      nom_slow_1p08V_125C:
        - pdk_dir::libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_1024x8_c2_bm_bist_slow_1p08V_125C.lib
    instances:
      top.sram:
        location: [50, 50]
        orientation: E

PDN_MACRO_CONNECTIONS:
  - "top.sram VPWR VGND VDD! VSS!"
  - "top.sram VPWR VGND VDDARRAY! VSS!"
```

Good luck!