import React from 'react';

import { render, screen, waitFor, act } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import '@testing-library/jest-dom';

import Tooltip from '.';

describe('Tooltip', () => {
  it('should show a text when mouse is hovering', async () => {
    const user = userEvent.setup();

    render(
      <div>
        <Tooltip content="This is my tooltip text">This is my anchor</Tooltip>
      </div>
    );

    expect(screen.queryByText('This is my tooltip text')).toBeNull();

    await act(async () => user.hover(screen.queryByText('This is my anchor')));

    await waitFor(() =>
      expect(screen.queryByText('This is my tooltip text')).toBeVisible()
    );
  });
});
