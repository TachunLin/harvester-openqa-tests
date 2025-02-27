## Test module loader

Usage: Define the test module execution order and condition

Normally the test schedule, that is which test modules should be executed and which order, is prescribed by the main.pm file within the test distribution. Additionally it is possible to exclude certain test modules from execution using the os-autoinst test variables INCLUDE_MODULES and EXCLUDE_MODULES. 

Refer to https://open.qa/docs/#_defining_a_custom_test_schedule_or_custom_test_modules  

1. We place test loader file in /var/lib/openqa/tests/opensuse/products/opensuse
