{-# LANGUAGE NoMonomorphismRestriction #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-|

-}
module Workflow.Derived where
import Workflow.Types

import Control.Monad.Trans.Free (intersperseT)
-- import Control.Monad.Free
import Numeric.Natural

--------------------------------------------------------------------------------
chord = sendKeyChord

insert = sendText

click :: (MonadWorkflow m) => [Modifier] -> Natural -> MouseButton -> m ()
click = sendMouseClick

scroll = sendMouseScroll

wait :: (MonadWorkflow m, Integral a) => a -> m ()
wait = delay . fromIntegral

--------------------------------------------------------------------------------

{-| intersperse a delay between each action.

@
delayWorkflowT 1 $ do
 sendKeyChord [CommandModifier] VKey
 s <- getClipboard
 sendText s
@

is equivalent to:

@
do
 sendKeyChord [CommandModifier] VKey
 delay 1
 s <- getClipboard
 delay 1
 sendText s
@

-}
delayWorkflowT :: (Monad m) => Int -> WorkflowT m a -> WorkflowT m a
delayWorkflowT t = intersperseT (Delay t ())
