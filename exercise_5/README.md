# Exercise 5 - The LibreLane API

LibreLane gives you access to its Python API, which allows you to programmatically configure flows and steps as well as create custom flows and steps.

## 5.1 - Using the API

How do we use the API? As always, there is some documentation: [`librelane` API](https://librelane.readthedocs.io/en/latest/reference/api/index.html).

That's quite a lot at once! Let's start with something already prepared.

Take a look at `flow.py` in this exercise. It is a Python script that uses the LibreLane API to start the Classic flow - just like we did before!

However, you can do much more! For example you can programmatically set the configuration variables, start flows in parallel, and postprocess the results.

> [!IMPORTANT]
> Before you start the flow, you need to explicitly enable the PDK so that the script can find it.
> Enable the latest version of the PDK using ciel: `ciel enable --pdk-family ihp-sg13g2 cb7daaa8901016cf7c5d272dfa322c41f024931f`

Now all you need to do to start the flow is to run the script:

```
python3 flow.py
```

Isn't that nice? Let's make some customizations.

## 5.3 - Custom Flow

In the documentation there is a section about creating custom flows via the API: [Using the API](https://librelane.readthedocs.io/en/latest/usage/writing_custom_flows.html#using-the-api)

Let's start simple. We want to create and register a new flow called `HeiChipsFlow` that inherits everything from the default flow, and we set the steps to be the same steps of the Classic flow.

Add that before the `main()` function:

```Python
@Flow.factory.register()
class HeiChipsFlow(Classic):
    """
    A flow that inherits most of the steps from the Classic flow.
    """

    Steps = Classic.Steps
```

Now we can simply choose to use the HeiChipsFlow:

```Python
	flow = HeiChipsFlow(
		flow_cfg,
		design_dir = ".",
		pdk_root   = None,
		pdk        = "ihp-sg13g2",
	)
```

And nothing changes. Don't believe me? Try it yourself:

```
python3 flow.py
```

That's boring. Let's add a new custom step!

## 5.3 - Custom Step

We want to create a new class called `HelloWorldStep` that inherits from `Step` and is registered using the `Step.factory`.

The id should be `HeiChips.HelloWorld` with the name `"Hello World!"`. There should be a single configuration variable named `HEICHIPS_SAY` of type `str` with a default value.

The `run()` function of the step should then simply say `"Hello World!"` plus whatever `HEICHIPS_SAY` is set to using the `info()` function. There should be no views or metrics updates.

Alright, that's a lot at once! How do you even get started? By reading similar code.

It helps to take a look at the codebase of LibreLane, let's say the [`KLayout.OpenGUI`](https://github.com/librelane/librelane/blob/d96f32212d025acd1d7acf01f395951cf3d4aa12/librelane/steps/klayout.py#L439) step. There is already a lot of code that you can use, and even more code that can be removed. Feel free to browse through the remaining codebase.

<details>
<summary>Spoiler: Solution</summary>

```Python
@Step.factory.register()
class HelloWorldStep(Step):
    """
    Says Hello World!
    """

    id = "HeiChips.HelloWorld"
    name = "Hello World!"

    config_vars = (
        [
            Variable(
                "HEICHIPS_SAY",
                str,
                "A string of what to say.",
                default="How are you?",
            ),
        ]
    )
    
    inputs = []
    outputs = []

    def run(self, state_in: State, **kwargs) -> Tuple[ViewsUpdate, MetricsUpdate]:

        info(f"Hello World! {self.config['HEICHIPS_SAY']}")

        return {}, {}
```
  
</details>

Now how do we add this step to our `HeiChipsFlow`? Like that:

```Python
@Flow.factory.register()
class HeiChipsFlow(Classic):
    """
    A flow that inherits most of the steps from the Classic flow.
    """

    Steps = Classic.Steps + [HelloWorldStep]
```

It will be inserted at the end of all existing steps.

Now run the flow:

```
────────────────────────────────────── Hello World! ──────────────────────────────────────
[19:51:23] VERBOSE  Running 'HeiChips.HelloWorld' at                          step.py:1140
                    'runs/RUN_2025-08-01_19-50-13/76-heichips-helloworld'…                
[19:51:23] INFO     Hello World! How are you?                                   flow.py:38
[19:51:23] INFO     Saving views to '...'                                     state.py:209
[19:51:23] INFO     Flow complete.                                       sequential.py:411

```

Success!

Let's customize or `HelloWorldStep` by adding the following variable to the flow configuration:

```
"HEICHIPS_SAY": "Howdy!"
```

Run the flow again, and you should see:

```
────────────────────────────────────── Hello World! ──────────────────────────────────────
[19:47:30] VERBOSE  Running 'HeiChips.HelloWorld' at                          step.py:1140
                    'runs/RUN_2025-08-01_19-46-20/76-heichips-helloworld'…                
[19:47:30] INFO     Hello World! Howdy!                                         flow.py:38
[19:47:30] INFO     Saving views to '...'                                     state.py:209
[19:47:30] INFO     Flow complete.                                       sequential.py:411
```

Success! Our very own customizable step 🎉

Of course, a proper step would manipulate the state in some way. But that can wait for another day ;)
