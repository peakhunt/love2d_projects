--
-- a rather strange system wide object initializer
--

--
-- just by requiring
-- factory objects are initialized with proper factory methods
-- looks like this is the only feasible method to avoid all the circular require 
-- problem
--
require('factory')
require('entities/factory')
require('scenes/factory')
require('top_factory')
