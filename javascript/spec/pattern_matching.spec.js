'use strict';

const chai = require('chai');
const expect = chai.expect;
chai.config.includeStack = true;

const match = require('./../src/pattern_matching');
const tautology = () => true;

describe('Pattern Matching', () => {
  describe('From a set of objects (that are not arrays)', () => {
    it('always matches sample case', () => {
      const n = 1;
      const alwaysMatches = match({n},
        tautology, ({ n }) => n);

      expect(alwaysMatches).to.equal(n);
    });
  });

  describe('From a set of arrays', () => {
    it('always matches sample case', () => {
      const n = 1;
      const alwaysMatches = match({n},
        [tautology, ({ n }) => n]);

      expect(alwaysMatches).to.equal(n);
    });

    it('can do recursion, specifying the clauses in order', () => {
      function alwaysMatches(n) {
        return match({n},
          [({n}) => n ===1, () => 2],
          [tautology, ({n}) => (1 + alwaysMatches(n-1))]);
      }

      expect(alwaysMatches(2)).to.equal(3);
    });


  });
  describe('sad paths', () => {
    it('will complain if the predicate is not a function', () => {
      const NOT_A_FUNCTION = 2;
      let exception = undefined;
      try {
        match({},
          [NOT_A_FUNCTION, tautology]);
      } catch (e) {
        expect(e).to.be.not.undefined;
        exception = e;
      }
      expect(exception).to.be.not.undefined;
    });
  });
});
