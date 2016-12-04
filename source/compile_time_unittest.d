module compile_time_unittest;

mixin template enableCompileTimeUnittest(string module_ = __MODULE__)
{
    version (unittest)
    {
        static import std.algorithm;
        mixin("static import " ~ module_ ~ ";");

        static if (std.algorithm.startsWith(mixin (module_).stringof, "module"))
        {
            static assert (
            {
                foreach (test; __traits (getUnitTests, mixin (module_)))
                {
                    test();
                }
                return true;
            }());
        }
        else
        {
            pragma (msg, "enableCompileTimeUnittest doesn't work because the module '" ~ module_ ~ "' has a symbol '" ~ module_ ~ "'");
        }
    }
}
