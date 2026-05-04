For the SDLC, I would like you to insert additional quality gates. 
1 - code coverage testing step, by using free/open source tools. The added code should have greater than 80% code coverage, under unit testing. 
2 - pre-commit hook execution. When the code is passing the QA stages, assume the repository has python and pre-commit installed, and attempt to call 'pre-commit run'

Update the framework accordingly

Update: The code coverage testing stage is attempting to run python diff-cover in go repositories. Is this the right approach? I think it's better to disable it. BTW, is our actions capable of being disabled, or at least can be triggered manually on demand? 
