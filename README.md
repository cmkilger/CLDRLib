#CLDRLib

CLDRLib is a library that aides developers to internationalize their software, using data from the [Unicode CLDR Project](http://cldr.unicode.org).

## Supported Languages & Features

### Objective-C

* Plural rules

## To do

* Completely use templates for code generation
* Add additional languages (e.g. Javascript, PHP, Ruby)
* Use additional CLDR data (e.g. ordinals, postal codes, territory info)


## Building

CLDRLib includes a script that uses templates to generate the library's code from CLDR data. It was written in Objective-C (because that's what I do) and will need to be compiled first.

1. Compile the script.

		$ clang -framework Foundation -o main main.m

2. Download the latest [CLDR data in JSON format](https://github.com/unicode-cldr/cldr-core/blob/master/supplemental/plurals.json) from GitHub.

3. Run the script with the path to the pluralization rules.

		$ ./main <cldr/supplemental/plural.json>

The library will then be found in `dist`.

## Usage

### Objective-C

**Note:** Apple has released `.stringsdict` files which handle plurals in localization and are more flexible than this, especially in that a sentence can contain more than one pluralization. It is recommended that you use that instead of this.

The easiest way to use `CLDRLib` is using the three macros which act similar to 
`NSLocalizedString()`:

* `CLDRPluralLocalizedStringWithCount(key, count, comment)`
* `CLDRPluralLocalizedStringWithAmount(key, count, comment)`
* `CLDRPluralLocalizedString(key, count, comment)`

In many languages, like English, decimals (i.e. "1.0") are handled differently than integers (i.e. "1"), so it can be important to distinguish between the two.

Example:

> This disk holds 1 gigabyte of data.

vs.

> This disk holds 1.0 gigabytes of data.

In CLDRLib, a count is an integer, and an amount is a decimal. If you pass a string, the library will attempt to determine which it is by looking for a decimal point (.). If a language uses a different character you can pass it into the options dictionary using `+[NSBundle pluralLocalizedStringForKey:options:value:table:]` with the key `CLDRPluralRuleOptionDecimalSeparator`.

The library will then look in `Localizable.strings` (or a different file if provided in the *tableName* parameter) for a key matching the key provided with the appropriate CLDR key appended. Example: `%d apples.other`.


## License

CLDRKit is licensed under the MIT license, which is reproduced in its entirety here:

>Copyright (c) 2010 Cory Kilger
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in
>all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>THE SOFTWARE.
