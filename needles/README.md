## Job Template

Usage: needles is used to perform fuzzy image matching between the screen and expected result

A needle consists of a full screenshot in PNG format and a json file with the same name (e.g. foo.png and foo.json) containing the associated data, like which areas inside the full screenshot are relevant or the mentioned list of tags.

Refer to https://open.qa/docs/#_needles 

1. We place needles files in /var/lib/openqa/tests/opensuse/products/opensuse/needles

2. Needles can be generated on the openQA dashboard 

{{< image "../images/openqa_dashboard_needles" >}}